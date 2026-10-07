# Third-party notices

`Lecoo-Control-Center-GUI` (`0.1.0`) is licensed under **GPL-3.0-only**; see [LICENSE](LICENSE).

This file records third-party components and runtime dependencies with their applicable licenses. Keep it with source and binary distributions.

## External runtime dependency

The GUI invokes `lecoo-ctrl` and `lecoo-ec-daemon` as separate processes; neither is linked into or bundled with the GUI. They are provided by [Lecoo-Control-Center](https://github.com/LaVashikk/Lecoo-Control-Center), licensed under MIT. Its license text appears below.

## Components

Versions are not repeated here; the build inputs are the canonical record.

### `MIT OR Apache-2.0` — 25 component(s)

Permissive, GPL-3.0 compatible.

| Component |
| --- |
| clang-format |
| cxx |
| cxx-gen |
| cxx-qt |
| cxx-qt-gen |
| cxx-qt-lib |
| cxx-qt-macro |
| cxxbridge-macro |
| hashbrown |
| indoc |
| link-cplusplus |
| proc-macro2 |
| quote |
| serde |
| serde_core |
| serde_derive |
| static_assertions |
| syn |
| syn |
| thiserror |
| thiserror-impl |
| unicode-segmentation |
| unicode-width |
| windows-link |
| windows-sys |

### `GPL-3.0-only OR LGPL-3.0-only OR LicenseRef-Qt-Commercial` — 4 component(s)

Qt 6 is tri-licensed. This application is GPL-3.0-only, so Qt is consumed under GPL-3.0-only, which needs no additional relinking provision because the whole distributed work is GPL-3.0. LGPL-3.0-only is a valid alternative for a differently licensed consumer, and the commercial option is available from The Qt Company.

Qt 6 components: qt6-5compat, qt6-base, qt6-declarative, qt6-shadertools.

### `Apache-2.0` — 3 component(s)

Permissive, GPL-3.0 compatible.

| Component |
| --- |
| codespan-reporting |
| Material Icons Round |
| Noto Sans SC |
| MaterialColorUtilities.js |

### `Apache-2.0 OR MIT` — 2 component(s)

Permissive, GPL-3.0 compatible.

| Component |
| --- |
| equivalent |
| indexmap |

### `Unlicense OR MIT` — 2 component(s)

Public-domain equivalent or MIT, GPL-3.0 compatible.

| Component |
| --- |
| termcolor |
| winapi-util |

### `(MIT OR Apache-2.0) AND Unicode-3.0` — 1 component(s)

Permissive (Unicode-3.0 is a BSD-style license), GPL-3.0 compatible.

| Component |
| --- |
| unicode-ident |

### `MIT` — 1 component(s)

Permissive, GPL-3.0 compatible.

| Component |
| --- |
| convert_case |

### `Zlib` — 1 component(s)

Permissive, GPL-3.0 compatible.

| Component |
| --- |
| foldhash |


## Bundled license texts

- **GPL-3.0-only** — [`LICENSE`](LICENSE), the application's own license.
Copyright notice for the vendored bundle, which ships without one:

```text
Copyright 2021 Google LLC
SPDX-License-Identifier: Apache-2.0
```

- **Apache-2.0** (Material Icons Round, the Rust dependencies, and the vendored
  `MaterialColorUtilities.js`) — [`assets/fonts/Apache-2.0-MaterialIcons.txt`](assets/fonts/Apache-2.0-MaterialIcons.txt).
- **SIL OFL-1.1** (Noto Sans SC) — [`assets/fonts/OFL-NotoSansSC.txt`](assets/fonts/OFL-NotoSansSC.txt).
- **MIT** (Rust dependencies and the external Lecoo-Control-Center CLI/daemon) — texts below.
- **Zlib** (the Rust dependencies that opt for it) — text below.
- **Unicode-3.0** (the Rust dependency that requires it) — text below.

```text
MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

MIT License for the external Lecoo-Control-Center CLI and daemon:

```text
MIT License

Copyright (c) 2026 LaVashikk

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

```text
zlib License

This software is provided 'as-is', without any express or implied warranty. In no event will
the authors be held liable for any damages arising from the use of this software.

Permission is granted to anyone to use this software for any purpose, including commercial
applications, and to alter it and redistribute it freely, subject to the following
restrictions:

1. The origin of this software must not be misrepresented; you must not claim that you wrote
   the original software. If you use this software in a product, an acknowledgment in the
   product documentation would be appreciated but is not required.
2. Altered source versions must be plainly marked as such, and must not be misrepresented as
   being the original software.
3. This notice may not be removed or altered from any source distribution.
```

```text
UNICODE LICENSE V3

COPYRIGHT AND PERMISSION NOTICE

Copyright © 1991-2024 Unicode, Inc.

NOTICE TO USER: Carefully read the following legal agreement. BY DOWNLOADING, INSTALLING,
COPYING OR OTHERWISE USING DATA FILES, AND/OR SOFTWARE, YOU UNEQUIVOCALLY ACCEPT, AND AGREE TO
BE BOUND BY, ALL OF THE TERMS AND CONDITIONS OF THIS AGREEMENT. IF YOU DO NOT AGREE, DO NOT
DOWNLOAD, INSTALL, COPY, DISTRIBUTE OR USE THE DATA FILES OR SOFTWARE.

Permission is hereby granted, free of charge, to any person obtaining a copy of data files and
any associated documentation (the "Data Files") or software and any associated documentation
(the "Software") to deal in the Data Files or Software without restriction, including without
limitation the rights to use, copy, modify, merge, publish, distribute, and/or sell copies of
the Data Files or Software, and to permit persons to whom the Data Files or Software are
furnished to do so, provided that either (a) this copyright and permission notice appear with
all copies of the Data Files or Software, or (b) this copyright and permission notice appear
in associated Documentation.

THE DATA FILES AND SOFTWARE ARE PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
PARTICULAR PURPOSE AND NONINFRINGEMENT OF THIRD PARTY RIGHTS. IN NO EVENT SHALL THE COPYRIGHT
HOLDER OR HOLDERS INCLUDED IN THIS NOTICE BE LIABLE FOR ANY CLAIM, OR ANY SPECIAL INDIRECT OR
CONSEQUENTIAL DAMAGES, OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
CONNECTION WITH THE USE OR PERFORMANCE OF THE DATA FILES OR SOFTWARE.

Except as contained in this notice, the name of a copyright holder shall not be used in
advertising or otherwise to promote the sale, use or other dealings in these Data Files or
Software without prior written authorization of the copyright holder.
```
