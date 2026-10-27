#include "qt_shim.h"

#include <QAction>
#include <QActionGroup>
#include <QApplication>
#include <QCoreApplication>
#include <QCursor>
#include <QFont>
#include <QFontDatabase>
#include <QGuiApplication>
#include <QIcon>
#include <QMenu>
#include <QPointer>
#include <QQuickStyle>
#include <QScreen>
#include <QSystemTrayIcon>
#include <QSysInfo>
#include <QWidget>

#include <vector>

void lecooSetApplicationIcon()
{
    QGuiApplication::setWindowIcon(QIcon(QStringLiteral(":/assets/app-icon.png")));
}

void lecooSetDesktopFileName(const QString &name)
{
    QGuiApplication::setDesktopFileName(name);
}

void lecooSetQuickControlsStyle(const QString &style)
{
    QQuickStyle::setStyle(style);
}

QString lecooSystemFontFamily()
{
    return QFontDatabase::systemFont(QFontDatabase::GeneralFont).family();
}

QString lecooFixedFontFamily()
{
    return QFontDatabase::systemFont(QFontDatabase::FixedFont).family();
}

QString lecooCursorScreenName()
{
    // Resolve the cursor screen across mixed-DPI coordinate systems.
    const QPoint pos = QCursor::pos();
    const QScreen *direct = QGuiApplication::screenAt(pos);
    if (direct)
        return direct->name();

    const QList<QScreen *> screens = QGuiApplication::screens();
    for (const QScreen *screen : screens) {
        const QRect logical = screen->geometry();
        const qreal ratio = screen->devicePixelRatio();
        const QPoint mapped = logical.topLeft()
                + QPoint(qRound((pos.x() - logical.x()) / ratio),
                         qRound((pos.y() - logical.y()) / ratio));
        if (logical.contains(mapped))
            return screen->name();
    }
    return QString();
}

QString lecooPlatformName()
{
    return QGuiApplication::platformName();
}

QString lecooOsName()
{
    // e.g. "Windows 11", "CachyOS Linux"
    const QString pretty = QSysInfo::prettyProductName();
    if (!pretty.isEmpty())
        return pretty;

    const QString type = QSysInfo::productType();
    if (!type.isEmpty())
        return type.front().toUpper() + type.mid(1);

    return QStringLiteral("Unknown OS");
}

QString lecooOsVersion()
{
    // e.g. "10.0.22631 · x86_64" on Windows, "6.12.4 · x86_64" on Linux
    const QString kernel = QSysInfo::kernelVersion();
    const QString arch = QSysInfo::currentCpuArchitecture();
    if (kernel.isEmpty())
        return arch;
    return kernel + QStringLiteral(" · ") + arch;
}

std::unique_ptr<QGuiApplication> lecooNewApplication(const QStringList &args)
{
    // Qt retains argc/argv, so their storage must outlive the application.
    static std::vector<QByteArray> bytes;
    static std::vector<char *> argv;
    static int argc;
    for (const auto &arg : args)
        bytes.push_back(arg.toLocal8Bit());
    for (auto &arg : bytes)
        argv.push_back(arg.data());
    argc = static_cast<int>(argv.size());
    argv.push_back(nullptr);
    return std::make_unique<QApplication>(argc, argv.data());
}

namespace {
// No custom meta-object or Rust callback ownership: Qt owns all tray objects.
class LecooTray : public QObject
{
public:
    explicit LecooTray(QObject &controller) : QObject(&controller), menu(new QMenu),
        icon(new QSystemTrayIcon(QIcon(QStringLiteral(":/assets/app-icon.png")), this))
    {
        icon->setToolTip(QStringLiteral("Lecoo Control Center"));
        icon->setContextMenu(menu.get());
        auto *group = new QActionGroup(this);
        group->setExclusive(true);
        for (int id = 0; id < 5; ++id) {
            if (id == 1 || id == 4)
                menu->addSeparator();
            auto *action = menu->addAction(QString());
            actions.append(action);
            if (id >= 1 && id <= 3) {
                action->setCheckable(true);
                group->addAction(action);
            }
            QObject::connect(action, &QAction::triggered, &controller, [&controller, id] {
                QMetaObject::invokeMethod(&controller, "handleTrayAction", Q_ARG(int, id));
            });
        }
        QObject::connect(icon, &QSystemTrayIcon::activated, &controller,
                         [&controller](QSystemTrayIcon::ActivationReason reason) {
            if (reason == QSystemTrayIcon::Trigger || reason == QSystemTrayIcon::DoubleClick)
                QMetaObject::invokeMethod(&controller, "handleTrayAction", Q_ARG(int, 0));
        });
        icon->show();
    }
    ~LecooTray() override { icon->hide(); icon->setContextMenu(nullptr); }
    std::unique_ptr<QMenu> menu;
    QSystemTrayIcon *icon;
    QList<QAction *> actions;
};
QPointer<LecooTray> tray;
}

bool lecooTrayAvailable()
{
    return QSystemTrayIcon::isSystemTrayAvailable();
}

void lecooInitTray(QObject &controller)
{
    if (!tray)
        tray = new LecooTray(controller);
}

void lecooTraySetMenu(const QStringList &items, int checkedIndex, bool enabled)
{
    if (!tray || items.size() != 5)
        return;
    for (int id = 0; id < 5; ++id) {
        auto *action = tray->actions[id];
        action->setText(items[id]);
        if (id >= 1 && id <= 3) {
            action->setChecked(id - 1 == checkedIndex);
            action->setEnabled(enabled);
        }
    }
}
