#include "qt_shim.h"

#include <QCursor>
#include <QFont>
#include <QFontDatabase>
#include <QGuiApplication>
#include <QIcon>
#include <QQuickStyle>
#include <QScreen>
#include <QSysInfo>

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
