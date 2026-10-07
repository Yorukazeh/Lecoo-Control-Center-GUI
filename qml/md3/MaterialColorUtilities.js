.pragma library
var __defProp = Object.defineProperty;
var __getOwnPropSymbols = Object.getOwnPropertySymbols;
var __hasOwnProp = Object.prototype.hasOwnProperty;
var __propIsEnum = Object.prototype.propertyIsEnumerable;
var __defNormalProp = (obj, key, value) => key in obj ? __defProp(obj, key, { enumerable: true, configurable: true, writable: true, value }) : obj[key] = value;
var __spreadValues = (a, b) => {
  for (var prop in b || (b = {}))
    if (__hasOwnProp.call(b, prop))
      __defNormalProp(a, prop, b[prop]);
  if (__getOwnPropSymbols)
    for (var prop of __getOwnPropSymbols(b)) {
      if (__propIsEnum.call(b, prop))
        __defNormalProp(a, prop, b[prop]);
    }
  return a;
};
function q(o) {
  return o < 0 ? -1 : o === 0 ? 0 : 1;
}
function lt(o, t, e) {
  return (1 - e) * o + e * t;
}
function $t(o, t, e) {
  return e < o ? o : e > t ? t : e;
}
function Y(o, t, e) {
  return e < o ? o : e > t ? t : e;
}
function pt(o) {
  return o = o % 360, o < 0 && (o = o + 360), o;
}
function K(o) {
  return o = o % 360, o < 0 && (o = o + 360), o;
}
function Xt(o, t) {
  return K(t - o) <= 180 ? 1 : -1;
}
function Lt(o, t) {
  return 180 - Math.abs(Math.abs(o - t) - 180);
}
function bt(o, t) {
  const e = o[0] * t[0][0] + o[1] * t[0][1] + o[2] * t[0][2], r = o[0] * t[1][0] + o[1] * t[1][1] + o[2] * t[1][2], n = o[0] * t[2][0] + o[1] * t[2][1] + o[2] * t[2][2];
  return [e, r, n];
}
const qt = [[0.41233895, 0.35762064, 0.18051042], [0.2126, 0.7152, 0.0722], [0.01932141, 0.11916382, 0.95034478]], me = [[3.2413774792388685, -1.5376652402851851, -0.49885366846268053], [-0.9691452513005321, 1.8758853451067872, 0.04156585616912061], [0.05562093689691305, -0.20395524564742123, 1.0571799111220335]], Mt = [95.047, 100, 108.883];
function gt(o, t, e) {
  return (255 << 24 | (o & 255) << 16 | (t & 255) << 8 | e & 255) >>> 0;
}
function Nt(o) {
  const t = it(o[0]), e = it(o[1]), r = it(o[2]);
  return gt(t, e, r);
}
function Vt(o) {
  return o >> 24 & 255;
}
function yt(o) {
  return o >> 16 & 255;
}
function Pt(o) {
  return o >> 8 & 255;
}
function Ct(o) {
  return o & 255;
}
function pe(o) {
  return Vt(o) >= 255;
}
function Ht(o, t, e) {
  const r = me, n = r[0][0] * o + r[0][1] * t + r[0][2] * e, a = r[1][0] * o + r[1][1] * t + r[1][2] * e, i = r[2][0] * o + r[2][1] * t + r[2][2] * e, u = it(n), f = it(a), p = it(i);
  return gt(u, f, p);
}
function jt(o) {
  const t = et(yt(o)), e = et(Pt(o)), r = et(Ct(o));
  return bt([t, e, r], qt);
}
function Wt(o, t, e) {
  const r = Mt, n = (o + 16) / 116, a = t / 500 + n, i = n - e / 200, u = Ft(a), f = Ft(n), p = Ft(i), l = u * r[0], y = f * r[1], P = p * r[2];
  return Ht(l, y, P);
}
function _t(o) {
  const t = et(yt(o)), e = et(Pt(o)), r = et(Ct(o)), n = qt, a = n[0][0] * t + n[0][1] * e + n[0][2] * r, i = n[1][0] * t + n[1][1] * e + n[1][2] * r, u = n[2][0] * t + n[2][1] * e + n[2][2] * r, f = Mt, p = a / f[0], l = i / f[1], y = u / f[2], P = At(p), g = At(l), m = At(y), d = 116 * g - 16, C = 500 * (P - g), D = 200 * (g - m);
  return [d, C, D];
}
function Jt(o) {
  const t = nt(o), e = it(t);
  return gt(e, e, e);
}
function wt(o) {
  const t = jt(o)[1];
  return 116 * At(t / 100) - 16;
}
function nt(o) {
  return 100 * Ft((o + 16) / 116);
}
function Et(o) {
  return At(o / 100) * 116 - 16;
}
function et(o) {
  const t = o / 255;
  return t <= 0.040449936 ? t / 12.92 * 100 : Math.pow((t + 0.055) / 1.055, 2.4) * 100;
}
function it(o) {
  const t = o / 100;
  let e = 0;
  return t <= 31308e-7 ? e = t * 12.92 : e = 1.055 * Math.pow(t, 1 / 2.4) - 0.055, $t(0, 255, Math.round(e * 255));
}
function Qt() {
  return Mt;
}
function At(o) {
  const t = 0.008856451679035631, e = 24389 / 27;
  return o > t ? Math.pow(o, 1 / 3) : (e * o + 16) / 116;
}
function Ft(o) {
  const t = 0.008856451679035631, e = 24389 / 27, r = o * o * o;
  return r > t ? r : (116 * o - 16) / e;
}
class Z {
  static make(t = Qt(), e = 200 / Math.PI * nt(50) / 100, r = 50, n = 2, a = false) {
    const i = t, u = i[0] * 0.401288 + i[1] * 0.650173 + i[2] * -0.051461, f = i[0] * -0.250268 + i[1] * 1.204414 + i[2] * 0.045854, p = i[0] * -2079e-6 + i[1] * 0.048952 + i[2] * 0.953127, l = 0.8 + n / 10, y = l >= 0.9 ? lt(0.59, 0.69, (l - 0.9) * 10) : lt(0.525, 0.59, (l - 0.8) * 10);
    let P = a ? 1 : l * (1 - 1 / 3.6 * Math.exp((-e - 42) / 92));
    P = P > 1 ? 1 : P < 0 ? 0 : P;
    const g = l, m = [P * (100 / u) + 1 - P, P * (100 / f) + 1 - P, P * (100 / p) + 1 - P], d = 1 / (5 * e + 1), C = d * d * d * d, D = 1 - C, T = C * e + 0.1 * D * D * Math.cbrt(5 * e), b = nt(r) / t[1], B = 1.48 + Math.sqrt(b), L = 0.725 / Math.pow(b, 0.2), M = L, S = [Math.pow(T * m[0] * u / 100, 0.42), Math.pow(T * m[1] * f / 100, 0.42), Math.pow(T * m[2] * p / 100, 0.42)], I = [400 * S[0] / (S[0] + 27.13), 400 * S[1] / (S[1] + 27.13), 400 * S[2] / (S[2] + 27.13)], N = (2 * I[0] + I[1] + 0.05 * I[2]) * L;
    return new Z(b, N, L, M, y, g, m, T, Math.pow(T, 0.25), B);
  }
  constructor(t, e, r, n, a, i, u, f, p, l) {
    this.n = t, this.aw = e, this.nbb = r, this.ncb = n, this.c = a, this.nc = i, this.rgbD = u, this.fl = f, this.fLRoot = p, this.z = l;
  }
}
Z.DEFAULT = Z.make();
class z {
  constructor(t, e, r, n, a, i, u, f, p) {
    this.hue = t, this.chroma = e, this.j = r, this.q = n, this.m = a, this.s = i, this.jstar = u, this.astar = f, this.bstar = p;
  }
  distance(t) {
    const e = this.jstar - t.jstar, r = this.astar - t.astar, n = this.bstar - t.bstar, a = Math.sqrt(e * e + r * r + n * n);
    return 1.41 * Math.pow(a, 0.63);
  }
  static fromInt(t) {
    return z.fromIntInViewingConditions(t, Z.DEFAULT);
  }
  static fromIntInViewingConditions(t, e) {
    const r = (t & 16711680) >> 16, n = (t & 65280) >> 8, a = t & 255, i = et(r), u = et(n), f = et(a), p = 0.41233895 * i + 0.35762064 * u + 0.18051042 * f, l = 0.2126 * i + 0.7152 * u + 0.0722 * f, y = 0.01932141 * i + 0.11916382 * u + 0.95034478 * f, P = 0.401288 * p + 0.650173 * l - 0.051461 * y, g = -0.250268 * p + 1.204414 * l + 0.045854 * y, m = -2079e-6 * p + 0.048952 * l + 0.953127 * y, d = e.rgbD[0] * P, C = e.rgbD[1] * g, D = e.rgbD[2] * m, T = Math.pow(e.fl * Math.abs(d) / 100, 0.42), b = Math.pow(e.fl * Math.abs(C) / 100, 0.42), B = Math.pow(e.fl * Math.abs(D) / 100, 0.42), L = q(d) * 400 * T / (T + 27.13), M = q(C) * 400 * b / (b + 27.13), S = q(D) * 400 * B / (B + 27.13), I = (11 * L + -12 * M + S) / 11, N = (L + M - 2 * S) / 9, O = (20 * L + 20 * M + 21 * S) / 20, X = (40 * L + 20 * M + S) / 20, tt = Math.atan2(N, I) * 180 / Math.PI, G = K(tt), ut = G * Math.PI / 180, St = X * e.nbb, ot = 100 * Math.pow(St / e.aw, e.c * e.z), kt = 4 / e.c * Math.sqrt(ot / 100) * (e.aw + 4) * e.fLRoot, vt = G < 20.14 ? G + 360 : G, Bt = 0.25 * (Math.cos(vt * Math.PI / 180 + 2) + 3.8), Ot = 5e4 / 13 * Bt * e.nc * e.ncb * Math.sqrt(I * I + N * N) / (O + 0.305), xt = Math.pow(Ot, 0.9) * Math.pow(1.64 - Math.pow(0.29, e.n), 0.73), Gt = xt * Math.sqrt(ot / 100), Yt = Gt * e.fLRoot, he = 50 * Math.sqrt(xt * e.c / (e.aw + 4)), le = (1 + 100 * 7e-3) * ot / (1 + 7e-3 * ot), Kt = 1 / 0.0228 * Math.log(1 + 0.0228 * Yt), fe = Kt * Math.cos(ut), de = Kt * Math.sin(ut);
    return new z(G, Gt, ot, kt, Yt, he, le, fe, de);
  }
  static fromJch(t, e, r) {
    return z.fromJchInViewingConditions(t, e, r, Z.DEFAULT);
  }
  static fromJchInViewingConditions(t, e, r, n) {
    const a = 4 / n.c * Math.sqrt(t / 100) * (n.aw + 4) * n.fLRoot, i = e * n.fLRoot, u = e / Math.sqrt(t / 100), f = 50 * Math.sqrt(u * n.c / (n.aw + 4)), p = r * Math.PI / 180, l = (1 + 100 * 7e-3) * t / (1 + 7e-3 * t), y = 1 / 0.0228 * Math.log(1 + 0.0228 * i), P = y * Math.cos(p), g = y * Math.sin(p);
    return new z(r, e, t, a, i, f, l, P, g);
  }
  static fromUcs(t, e, r) {
    return z.fromUcsInViewingConditions(t, e, r, Z.DEFAULT);
  }
  static fromUcsInViewingConditions(t, e, r, n) {
    const a = e, i = r, u = Math.sqrt(a * a + i * i), p = (Math.exp(u * 0.0228) - 1) / 0.0228 / n.fLRoot;
    let l = Math.atan2(i, a) * (180 / Math.PI);
    l < 0 && (l += 360);
    const y = t / (1 - (t - 100) * 7e-3);
    return z.fromJchInViewingConditions(y, p, l, n);
  }
  toInt() {
    return this.viewed(Z.DEFAULT);
  }
  viewed(t) {
    const e = this.chroma === 0 || this.j === 0 ? 0 : this.chroma / Math.sqrt(this.j / 100), r = Math.pow(e / Math.pow(1.64 - Math.pow(0.29, t.n), 0.73), 1 / 0.9), n = this.hue * Math.PI / 180, a = 0.25 * (Math.cos(n + 2) + 3.8), i = t.aw * Math.pow(this.j / 100, 1 / t.c / t.z), u = a * (5e4 / 13) * t.nc * t.ncb, f = i / t.nbb, p = Math.sin(n), l = Math.cos(n), y = 23 * (f + 0.305) * r / (23 * u + 11 * r * l + 108 * r * p), P = y * l, g = y * p, m = (460 * f + 451 * P + 288 * g) / 1403, d = (460 * f - 891 * P - 261 * g) / 1403, C = (460 * f - 220 * P - 6300 * g) / 1403, D = Math.max(0, 27.13 * Math.abs(m) / (400 - Math.abs(m))), T = q(m) * (100 / t.fl) * Math.pow(D, 1 / 0.42), b = Math.max(0, 27.13 * Math.abs(d) / (400 - Math.abs(d))), B = q(d) * (100 / t.fl) * Math.pow(b, 1 / 0.42), L = Math.max(0, 27.13 * Math.abs(C) / (400 - Math.abs(C))), M = q(C) * (100 / t.fl) * Math.pow(L, 1 / 0.42), S = T / t.rgbD[0], I = B / t.rgbD[1], N = M / t.rgbD[2], O = 1.86206786 * S - 1.01125463 * I + 0.14918677 * N, X = 0.38752654 * S + 0.62144744 * I - 897398e-8 * N, W = -0.0158415 * S - 0.03412294 * I + 1.04996444 * N;
    return Ht(O, X, W);
  }
  static fromXyzInViewingConditions(t, e, r, n) {
    const a = 0.401288 * t + 0.650173 * e - 0.051461 * r, i = -0.250268 * t + 1.204414 * e + 0.045854 * r, u = -2079e-6 * t + 0.048952 * e + 0.953127 * r, f = n.rgbD[0] * a, p = n.rgbD[1] * i, l = n.rgbD[2] * u, y = Math.pow(n.fl * Math.abs(f) / 100, 0.42), P = Math.pow(n.fl * Math.abs(p) / 100, 0.42), g = Math.pow(n.fl * Math.abs(l) / 100, 0.42), m = q(f) * 400 * y / (y + 27.13), d = q(p) * 400 * P / (P + 27.13), C = q(l) * 400 * g / (g + 27.13), D = (11 * m + -12 * d + C) / 11, T = (m + d - 2 * C) / 9, b = (20 * m + 20 * d + 21 * C) / 20, B = (40 * m + 20 * d + C) / 20, M = Math.atan2(T, D) * 180 / Math.PI, S = M < 0 ? M + 360 : M >= 360 ? M - 360 : M, I = S * Math.PI / 180, N = B * n.nbb, O = 100 * Math.pow(N / n.aw, n.c * n.z), X = 4 / n.c * Math.sqrt(O / 100) * (n.aw + 4) * n.fLRoot, W = S < 20.14 ? S + 360 : S, tt = 1 / 4 * (Math.cos(W * Math.PI / 180 + 2) + 3.8), ut = 5e4 / 13 * tt * n.nc * n.ncb * Math.sqrt(D * D + T * T) / (b + 0.305), St = Math.pow(ut, 0.9) * Math.pow(1.64 - Math.pow(0.29, n.n), 0.73), ot = St * Math.sqrt(O / 100), kt = ot * n.fLRoot, vt = 50 * Math.sqrt(St * n.c / (n.aw + 4)), Bt = (1 + 100 * 7e-3) * O / (1 + 7e-3 * O), Rt = Math.log(1 + 0.0228 * kt) / 0.0228, Ot = Rt * Math.cos(I), xt = Rt * Math.sin(I);
    return new z(S, ot, O, X, kt, vt, Bt, Ot, xt);
  }
  xyzInViewingConditions(t) {
    const e = this.chroma === 0 || this.j === 0 ? 0 : this.chroma / Math.sqrt(this.j / 100), r = Math.pow(e / Math.pow(1.64 - Math.pow(0.29, t.n), 0.73), 1 / 0.9), n = this.hue * Math.PI / 180, a = 0.25 * (Math.cos(n + 2) + 3.8), i = t.aw * Math.pow(this.j / 100, 1 / t.c / t.z), u = a * (5e4 / 13) * t.nc * t.ncb, f = i / t.nbb, p = Math.sin(n), l = Math.cos(n), y = 23 * (f + 0.305) * r / (23 * u + 11 * r * l + 108 * r * p), P = y * l, g = y * p, m = (460 * f + 451 * P + 288 * g) / 1403, d = (460 * f - 891 * P - 261 * g) / 1403, C = (460 * f - 220 * P - 6300 * g) / 1403, D = Math.max(0, 27.13 * Math.abs(m) / (400 - Math.abs(m))), T = q(m) * (100 / t.fl) * Math.pow(D, 1 / 0.42), b = Math.max(0, 27.13 * Math.abs(d) / (400 - Math.abs(d))), B = q(d) * (100 / t.fl) * Math.pow(b, 1 / 0.42), L = Math.max(0, 27.13 * Math.abs(C) / (400 - Math.abs(C))), M = q(C) * (100 / t.fl) * Math.pow(L, 1 / 0.42), S = T / t.rgbD[0], I = B / t.rgbD[1], N = M / t.rgbD[2], O = 1.86206786 * S - 1.01125463 * I + 0.14918677 * N, X = 0.38752654 * S + 0.62144744 * I - 897398e-8 * N, W = -0.0158415 * S - 0.03412294 * I + 1.04996444 * N;
    return [O, X, W];
  }
}
class E {
  static sanitizeRadians(t) {
    return (t + Math.PI * 8) % (Math.PI * 2);
  }
  static trueDelinearized(t) {
    const e = t / 100;
    let r = 0;
    return e <= 31308e-7 ? r = e * 12.92 : r = 1.055 * Math.pow(e, 1 / 2.4) - 0.055, r * 255;
  }
  static chromaticAdaptation(t) {
    const e = Math.pow(Math.abs(t), 0.42);
    return q(t) * 400 * e / (e + 27.13);
  }
  static hueOf(t) {
    const e = bt(t, E.SCALED_DISCOUNT_FROM_LINRGB), r = E.chromaticAdaptation(e[0]), n = E.chromaticAdaptation(e[1]), a = E.chromaticAdaptation(e[2]), i = (11 * r + -12 * n + a) / 11, u = (r + n - 2 * a) / 9;
    return Math.atan2(u, i);
  }
  static areInCyclicOrder(t, e, r) {
    const n = E.sanitizeRadians(e - t), a = E.sanitizeRadians(r - t);
    return n < a;
  }
  static intercept(t, e, r) {
    return (e - t) / (r - t);
  }
  static lerpPoint(t, e, r) {
    return [t[0] + (r[0] - t[0]) * e, t[1] + (r[1] - t[1]) * e, t[2] + (r[2] - t[2]) * e];
  }
  static setCoordinate(t, e, r, n) {
    const a = E.intercept(t[n], e, r[n]);
    return E.lerpPoint(t, a, r);
  }
  static isBounded(t) {
    return 0 <= t && t <= 100;
  }
  static nthVertex(t, e) {
    const r = E.Y_FROM_LINRGB[0], n = E.Y_FROM_LINRGB[1], a = E.Y_FROM_LINRGB[2], i = e % 4 <= 1 ? 0 : 100, u = e % 2 === 0 ? 0 : 100;
    if (e < 4) {
      const f = i, p = u, l = (t - f * n - p * a) / r;
      return E.isBounded(l) ? [l, f, p] : [-1, -1, -1];
    } else if (e < 8) {
      const f = i, p = u, l = (t - p * r - f * a) / n;
      return E.isBounded(l) ? [p, l, f] : [-1, -1, -1];
    } else {
      const f = i, p = u, l = (t - f * r - p * n) / a;
      return E.isBounded(l) ? [f, p, l] : [-1, -1, -1];
    }
  }
  static bisectToSegment(t, e) {
    let r = [-1, -1, -1], n = r, a = 0, i = 0, u = false, f = true;
    for (let p = 0; p < 12; p++) {
      const l = E.nthVertex(t, p);
      if (l[0] < 0) continue;
      const y = E.hueOf(l);
      if (!u) {
        r = l, n = l, a = y, i = y, u = true;
        continue;
      }
      (f || E.areInCyclicOrder(a, y, i)) && (f = false, E.areInCyclicOrder(a, e, y) ? (n = l, i = y) : (r = l, a = y));
    }
    return [r, n];
  }
  static midpoint(t, e) {
    return [(t[0] + e[0]) / 2, (t[1] + e[1]) / 2, (t[2] + e[2]) / 2];
  }
  static criticalPlaneBelow(t) {
    return Math.floor(t - 0.5);
  }
  static criticalPlaneAbove(t) {
    return Math.ceil(t - 0.5);
  }
  static bisectToLimit(t, e) {
    const r = E.bisectToSegment(t, e);
    let n = r[0], a = E.hueOf(n), i = r[1];
    for (let u = 0; u < 3; u++) if (n[u] !== i[u]) {
      let f = -1, p = 255;
      n[u] < i[u] ? (f = E.criticalPlaneBelow(E.trueDelinearized(n[u])), p = E.criticalPlaneAbove(E.trueDelinearized(i[u]))) : (f = E.criticalPlaneAbove(E.trueDelinearized(n[u])), p = E.criticalPlaneBelow(E.trueDelinearized(i[u])));
      for (let l = 0; l < 8 && !(Math.abs(p - f) <= 1); l++) {
        const y = Math.floor((f + p) / 2), P = E.CRITICAL_PLANES[y], g = E.setCoordinate(n, P, i, u), m = E.hueOf(g);
        E.areInCyclicOrder(a, e, m) ? (i = g, p = y) : (n = g, a = m, f = y);
      }
    }
    return E.midpoint(n, i);
  }
  static inverseChromaticAdaptation(t) {
    const e = Math.abs(t), r = Math.max(0, 27.13 * e / (400 - e));
    return q(t) * Math.pow(r, 1 / 0.42);
  }
  static findResultByJ(t, e, r) {
    let n = Math.sqrt(r) * 11;
    const a = Z.DEFAULT, i = 1 / Math.pow(1.64 - Math.pow(0.29, a.n), 0.73), f = 0.25 * (Math.cos(t + 2) + 3.8) * (5e4 / 13) * a.nc * a.ncb, p = Math.sin(t), l = Math.cos(t);
    for (let y = 0; y < 5; y++) {
      const P = n / 100, g = e === 0 || n === 0 ? 0 : e / Math.sqrt(P), m = Math.pow(g * i, 1 / 0.9), C = a.aw * Math.pow(P, 1 / a.c / a.z) / a.nbb, D = 23 * (C + 0.305) * m / (23 * f + 11 * m * l + 108 * m * p), T = D * l, b = D * p, B = (460 * C + 451 * T + 288 * b) / 1403, L = (460 * C - 891 * T - 261 * b) / 1403, M = (460 * C - 220 * T - 6300 * b) / 1403, S = E.inverseChromaticAdaptation(B), I = E.inverseChromaticAdaptation(L), N = E.inverseChromaticAdaptation(M), O = bt([S, I, N], E.LINRGB_FROM_SCALED_DISCOUNT);
      if (O[0] < 0 || O[1] < 0 || O[2] < 0) return 0;
      const X = E.Y_FROM_LINRGB[0], W = E.Y_FROM_LINRGB[1], tt = E.Y_FROM_LINRGB[2], G = X * O[0] + W * O[1] + tt * O[2];
      if (G <= 0) return 0;
      if (y === 4 || Math.abs(G - r) < 2e-3) return O[0] > 100.01 || O[1] > 100.01 || O[2] > 100.01 ? 0 : Nt(O);
      n = n - (G - r) * n / (2 * G);
    }
    return 0;
  }
  static solveToInt(t, e, r) {
    if (e < 1e-4 || r < 1e-4 || r > 99.9999) return Jt(r);
    t = K(t);
    const n = t / 180 * Math.PI, a = nt(r), i = E.findResultByJ(n, e, a);
    if (i !== 0) return i;
    const u = E.bisectToLimit(a, n);
    return Nt(u);
  }
  static solveToCam(t, e, r) {
    return z.fromInt(E.solveToInt(t, e, r));
  }
}
E.SCALED_DISCOUNT_FROM_LINRGB = [[0.001200833568784504, 0.002389694492170889, 2795742885861124e-19], [5891086651375999e-19, 0.0029785502573438758, 3270666104008398e-19], [10146692491640572e-20, 5364214359186694e-19, 0.0032979401770712076]], E.LINRGB_FROM_SCALED_DISCOUNT = [[1373.2198709594231, -1100.4251190754821, -7.278681089101213], [-271.815969077903, 559.6580465940733, -32.46047482791194], [1.9622899599665666, -57.173814538844006, 308.7233197812385]], E.Y_FROM_LINRGB = [0.2126, 0.7152, 0.0722], E.CRITICAL_PLANES = [0.015176349177441876, 0.045529047532325624, 0.07588174588720938, 0.10623444424209313, 0.13658714259697685, 0.16693984095186062, 0.19729253930674434, 0.2276452376616281, 0.2579979360165119, 0.28835063437139563, 0.3188300904430532, 0.350925934958123, 0.3848314933096426, 0.42057480301049466, 0.458183274052838, 0.4976837250274023, 0.5391024159806381, 0.5824650784040898, 0.6277969426914107, 0.6751227633498623, 0.7244668422128921, 0.775853049866786, 0.829304845476233, 0.8848452951698498, 0.942497089126609, 1.0022825574869039, 1.0642236851973577, 1.1283421258858297, 1.1946592148522128, 1.2631959812511864, 1.3339731595349034, 1.407011200216447, 1.4823302800086415, 1.5599503113873272, 1.6398909516233677, 1.7221716113234105, 1.8068114625156377, 1.8938294463134073, 1.9832442801866852, 2.075074464868551, 2.1693382909216234, 2.2660538449872063, 2.36523901573795, 2.4669114995532007, 2.5710888059345764, 2.6777882626779785, 2.7870270208169257, 2.898822059350997, 3.0131901897720907, 3.1301480604002863, 3.2497121605402226, 3.3718988244681087, 3.4967242352587946, 3.624204428461639, 3.754355295633311, 3.887192587735158, 4.022731918402185, 4.160988767090289, 4.301978482107941, 4.445716283538092, 4.592217266055746, 4.741496401646282, 4.893568542229298, 5.048448422192488, 5.20615066083972, 5.3666897647573375, 5.5300801301023865, 5.696336044816294, 5.865471690767354, 6.037501145825082, 6.212438385869475, 6.390297286737924, 6.571091626112461, 6.7548350853498045, 6.941541251256611, 7.131223617812143, 7.323895587840543, 7.5195704746346665, 7.7182615035334345, 7.919981813454504, 8.124744458384042, 8.332562408825165, 8.543448553206703, 8.757415699253682, 8.974476575321063, 9.194643831691977, 9.417930041841839, 9.644347703669503, 9.873909240696694, 10.106627003236781, 10.342513269534024, 10.58158024687427, 10.8238400726681, 11.069304815507364, 11.317986476196008, 11.569896988756009, 11.825048221409341, 12.083451977536606, 12.345119996613247, 12.610063955123938, 12.878295467455942, 13.149826086772048, 13.42466730586372, 13.702830557985108, 13.984327217668513, 14.269168601521828, 14.55736596900856, 14.848930523210871, 15.143873411576273, 15.44220572664832, 15.743938506781891, 16.04908273684337, 16.35764934889634, 16.66964922287304, 16.985093187232053, 17.30399201960269, 17.62635644741625, 17.95219714852476, 18.281524751807332, 18.614349837764564, 18.95068293910138, 19.290534541298456, 19.633915083172692, 19.98083495742689, 20.331304511189067, 20.685334046541502, 21.042933821039977, 21.404114048223256, 21.76888489811322, 22.137256497705877, 22.50923893145328, 22.884842241736916, 23.264076429332462, 23.6469514538663, 24.033477234264016, 24.42366364919083, 24.817520537484558, 25.21505769858089, 25.61628489293138, 26.021211842414342, 26.429848230738664, 26.842203703840827, 27.258287870275353, 27.678110301598522, 28.10168053274597, 28.529008062403893, 28.96010235337422, 29.39497283293396, 29.83362889318845, 30.276079891419332, 30.722335150426627, 31.172403958865512, 31.62629557157785, 32.08401920991837, 32.54558406207592, 33.010999283389665, 33.4802739966603, 33.953417292456834, 34.430438229418264, 34.911345834551085, 35.39614910352207, 35.88485700094671, 36.37747846067349, 36.87402238606382, 37.37449765026789, 37.87891309649659, 38.38727753828926, 38.89959975977785, 39.41588851594697, 39.93615253289054, 40.460400508064545, 40.98864111053629, 41.520882981230194, 42.05713473317016, 42.597404951718396, 43.141702194811224, 43.6900349931913, 44.24241185063697, 44.798841244188324, 45.35933162437017, 45.92389141541209, 46.49252901546552, 47.065252796817916, 47.64207110610409, 48.22299226451468, 48.808024568002054, 49.3971762874833, 49.9904556690408, 50.587870934119984, 51.189430279724725, 51.79514187861014, 52.40501387947288, 53.0190544071392, 53.637271562750364, 54.259673423945976, 54.88626804504493, 55.517063457223934, 56.15206766869424, 56.79128866487574, 57.43473440856916, 58.08241284012621, 58.734331877617365, 59.39049941699807, 60.05092333227251, 60.715611475655585, 61.38457167773311, 62.057811747619894, 62.7353394731159, 63.417162620860914, 64.10328893648692, 64.79372614476921, 65.48848194977529, 66.18756403501224, 66.89098006357258, 67.59873767827808, 68.31084450182222, 69.02730813691093, 69.74813616640164, 70.47333615344107, 71.20291564160104, 71.93688215501312, 72.67524319850172, 73.41800625771542, 74.16517879925733, 74.9167682708136, 75.67278210128072, 76.43322770089146, 77.1981124613393, 77.96744375590167, 78.74122893956174, 79.51947534912904, 80.30219030335869, 81.08938110306934, 81.88105503125999, 82.67721935322541, 83.4778813166706, 84.28304815182372, 85.09272707154808, 85.90692527145302, 86.72564993000343, 87.54890820862819, 88.3767072518277, 89.2090541872801, 90.04595612594655, 90.88742016217518, 91.73345337380438, 92.58406282226491, 93.43925555268066, 94.29903859396902, 95.16341895893969, 96.03240364439274, 96.9059996312159, 97.78421388448044, 98.6670533535366, 99.55452497210776];
class x {
  static from(t, e, r) {
    return new x(E.solveToInt(t, e, r));
  }
  static fromInt(t) {
    return new x(t);
  }
  toInt() {
    return this.argb;
  }
  get hue() {
    return this.internalHue;
  }
  set hue(t) {
    this.setInternalState(E.solveToInt(t, this.internalChroma, this.internalTone));
  }
  get chroma() {
    return this.internalChroma;
  }
  set chroma(t) {
    this.setInternalState(E.solveToInt(this.internalHue, t, this.internalTone));
  }
  get tone() {
    return this.internalTone;
  }
  set tone(t) {
    this.setInternalState(E.solveToInt(this.internalHue, this.internalChroma, t));
  }
  setValue(t, e) {
    this[t] = e;
  }
  toString() {
    return `HCT(${this.hue.toFixed(0)}, ${this.chroma.toFixed(0)}, ${this.tone.toFixed(0)})`;
  }
  static isBlue(t) {
    return t >= 250 && t < 270;
  }
  static isYellow(t) {
    return t >= 105 && t < 125;
  }
  static isCyan(t) {
    return t >= 170 && t < 207;
  }
  constructor(t) {
    this.argb = t;
    const e = z.fromInt(t);
    this.internalHue = e.hue, this.internalChroma = e.chroma, this.internalTone = wt(t), this.argb = t;
  }
  setInternalState(t) {
    const e = z.fromInt(t);
    this.internalHue = e.hue, this.internalChroma = e.chroma, this.internalTone = wt(t), this.argb = t;
  }
  inViewingConditions(t) {
    const r = z.fromInt(this.toInt()).xyzInViewingConditions(t), n = z.fromXyzInViewingConditions(r[0], r[1], r[2], Z.make());
    return x.from(n.hue, n.chroma, Et(r[1]));
  }
}
class It {
  static harmonize(t, e) {
    const r = x.fromInt(t), n = x.fromInt(e), a = Lt(r.hue, n.hue), i = Math.min(a * 0.5, 15), u = K(r.hue + i * Xt(r.hue, n.hue));
    return x.from(u, r.chroma, r.tone).toInt();
  }
  static hctHue(t, e, r) {
    const n = It.cam16Ucs(t, e, r), a = z.fromInt(n), i = z.fromInt(t);
    return x.from(a.hue, i.chroma, wt(t)).toInt();
  }
  static cam16Ucs(t, e, r) {
    const n = z.fromInt(t), a = z.fromInt(e), i = n.jstar, u = n.astar, f = n.bstar, p = a.jstar, l = a.astar, y = a.bstar, P = i + (p - i) * r, g = u + (l - u) * r, m = f + (y - f) * r;
    return z.fromUcs(P, g, m).toInt();
  }
}
class H {
  static ratioOfTones(t, e) {
    return t = Y(0, 100, t), e = Y(0, 100, e), H.ratioOfYs(nt(t), nt(e));
  }
  static ratioOfYs(t, e) {
    const r = t > e ? t : e, n = r === e ? t : e;
    return (r + 5) / (n + 5);
  }
  static lighter(t, e) {
    if (t < 0 || t > 100) return -1;
    const r = nt(t), n = e * (r + 5) - 5, a = H.ratioOfYs(n, r), i = Math.abs(a - e);
    if (a < e && i > 0.04) return -1;
    const u = Et(n) + 0.4;
    return u < 0 || u > 100 ? -1 : u;
  }
  static darker(t, e) {
    if (t < 0 || t > 100) return -1;
    const r = nt(t), n = (r + 5) / e - 5, a = H.ratioOfYs(r, n), i = Math.abs(a - e);
    if (a < e && i > 0.04) return -1;
    const u = Et(n) - 0.4;
    return u < 0 || u > 100 ? -1 : u;
  }
  static lighterUnsafe(t, e) {
    const r = H.lighter(t, e);
    return r < 0 ? 100 : r;
  }
  static darkerUnsafe(t, e) {
    const r = H.darker(t, e);
    return r < 0 ? 0 : r;
  }
}
class mt {
  static isDisliked(t) {
    const e = Math.round(t.hue) >= 90 && Math.round(t.hue) <= 111, r = Math.round(t.chroma) > 16, n = Math.round(t.tone) < 65;
    return e && r && n;
  }
  static fixIfDisliked(t) {
    return mt.isDisliked(t) ? x.from(t.hue, t.chroma, 70) : t;
  }
}
function ge(o, t, e) {
  if (o.name !== e.name) throw new Error(`Attempting to extend color ${o.name} with color ${e.name} of different name for spec version ${t}.`);
  if (o.isBackground !== e.isBackground) throw new Error(`Attempting to extend color ${o.name} as a ${o.isBackground ? "background" : "foreground"} with color ${e.name} as a ${e.isBackground ? "background" : "foreground"} for spec version ${t}.`);
}
function F(o, t, e) {
  return ge(o, t, e), h.fromPalette({ name: o.name, palette: (r) => r.specVersion === t ? e.palette(r) : o.palette(r), tone: (r) => r.specVersion === t ? e.tone(r) : o.tone(r), isBackground: o.isBackground, chromaMultiplier: (r) => {
    const n = r.specVersion === t ? e.chromaMultiplier : o.chromaMultiplier;
    return n !== void 0 ? n(r) : 1;
  }, background: (r) => {
    const n = r.specVersion === t ? e.background : o.background;
    return n !== void 0 ? n(r) : void 0;
  }, secondBackground: (r) => {
    const n = r.specVersion === t ? e.secondBackground : o.secondBackground;
    return n !== void 0 ? n(r) : void 0;
  }, contrastCurve: (r) => {
    const n = r.specVersion === t ? e.contrastCurve : o.contrastCurve;
    return n !== void 0 ? n(r) : void 0;
  }, toneDeltaPair: (r) => {
    const n = r.specVersion === t ? e.toneDeltaPair : o.toneDeltaPair;
    return n !== void 0 ? n(r) : void 0;
  } });
}
class h {
  static fromPalette(t) {
    var _a, _b, _c;
    return new h((_a = t.name) != null ? _a : "", t.palette, (_b = t.tone) != null ? _b : h.getInitialToneFromBackground(t.background), (_c = t.isBackground) != null ? _c : false, t.chromaMultiplier, t.background, t.secondBackground, t.contrastCurve, t.toneDeltaPair);
  }
  static getInitialToneFromBackground(t) {
    return t === void 0 ? (e) => 50 : (e) => t(e) ? t(e).getTone(e) : 50;
  }
  constructor(t, e, r, n, a, i, u, f, p) {
    if (this.name = t, this.palette = e, this.tone = r, this.isBackground = n, this.chromaMultiplier = a, this.background = i, this.secondBackground = u, this.contrastCurve = f, this.toneDeltaPair = p, this.hctCache = /* @__PURE__ */ new Map(), !i && u) throw new Error(`Color ${t} has secondBackgrounddefined, but background is not defined.`);
    if (!i && f) throw new Error(`Color ${t} has contrastCurvedefined, but background is not defined.`);
    if (i && !f) throw new Error(`Color ${t} has backgrounddefined, but contrastCurve is not defined.`);
  }
  clone() {
    return h.fromPalette({ name: this.name, palette: this.palette, tone: this.tone, isBackground: this.isBackground, chromaMultiplier: this.chromaMultiplier, background: this.background, secondBackground: this.secondBackground, contrastCurve: this.contrastCurve, toneDeltaPair: this.toneDeltaPair });
  }
  clearCache() {
    this.hctCache.clear();
  }
  getArgb(t) {
    return this.getHct(t).toInt();
  }
  getHct(t) {
    const e = this.hctCache.get(t);
    if (e != null) return e;
    const r = Zt(t.specVersion).getHct(t, this);
    return this.hctCache.size > 4 && this.hctCache.clear(), this.hctCache.set(t, r), r;
  }
  getTone(t) {
    return Zt(t.specVersion).getTone(t, this);
  }
  static foregroundTone(t, e) {
    const r = H.lighterUnsafe(t, e), n = H.darkerUnsafe(t, e), a = H.ratioOfTones(r, t), i = H.ratioOfTones(n, t);
    if (h.tonePrefersLightForeground(t)) {
      const f = Math.abs(a - i) < 0.1 && a < e && i < e;
      return a >= e || a >= i || f ? r : n;
    } else return i >= e || i >= a ? n : r;
  }
  static tonePrefersLightForeground(t) {
    return Math.round(t) < 60;
  }
  static toneAllowsLightForeground(t) {
    return Math.round(t) <= 49;
  }
  static enableLightForeground(t) {
    return h.tonePrefersLightForeground(t) && !h.toneAllowsLightForeground(t) ? 49 : t;
  }
}
class ye {
  getHct(t, e) {
    const r = e.getTone(t);
    return e.palette(t).getHct(r);
  }
  getTone(t, e) {
    const r = t.contrastLevel < 0, n = e.toneDeltaPair ? e.toneDeltaPair(t) : void 0;
    if (n) {
      const a = n.roleA, i = n.roleB, u = n.delta, f = n.polarity, p = n.stayTogether, l = f === "nearer" || f === "lighter" && !t.isDark || f === "darker" && t.isDark, y = l ? a : i, P = l ? i : a, g = e.name === y.name, m = t.isDark ? 1 : -1;
      let d = y.tone(t), C = P.tone(t);
      if (e.background && y.contrastCurve && P.contrastCurve) {
        const D = e.background(t), T = y.contrastCurve(t), b = P.contrastCurve(t);
        if (D && T && b) {
          const B = D.getTone(t), L = T.get(t.contrastLevel), M = b.get(t.contrastLevel);
          H.ratioOfTones(B, d) < L && (d = h.foregroundTone(B, L)), H.ratioOfTones(B, C) < M && (C = h.foregroundTone(B, M)), r && (d = h.foregroundTone(B, L), C = h.foregroundTone(B, M));
        }
      }
      return (C - d) * m < u && (C = Y(0, 100, d + u * m), (C - d) * m >= u || (d = Y(0, 100, C - u * m))), 50 <= d && d < 60 ? m > 0 ? (d = 60, C = Math.max(C, d + u * m)) : (d = 49, C = Math.min(C, d + u * m)) : 50 <= C && C < 60 && (p ? m > 0 ? (d = 60, C = Math.max(C, d + u * m)) : (d = 49, C = Math.min(C, d + u * m)) : m > 0 ? C = 60 : C = 49), g ? d : C;
    } else {
      let a = e.tone(t);
      if (e.background == null || e.background(t) === void 0 || e.contrastCurve == null || e.contrastCurve(t) === void 0) return a;
      const i = e.background(t).getTone(t), u = e.contrastCurve(t).get(t.contrastLevel);
      if (H.ratioOfTones(i, a) >= u || (a = h.foregroundTone(i, u)), r && (a = h.foregroundTone(i, u)), e.isBackground && 50 <= a && a < 60 && (H.ratioOfTones(49, i) >= u ? a = 49 : a = 60), e.secondBackground == null || e.secondBackground(t) === void 0) return a;
      const [f, p] = [e.background, e.secondBackground], [l, y] = [f(t).getTone(t), p(t).getTone(t)], [P, g] = [Math.max(l, y), Math.min(l, y)];
      if (H.ratioOfTones(P, a) >= u && H.ratioOfTones(g, a) >= u) return a;
      const m = H.lighter(P, u), d = H.darker(g, u), C = [];
      return m !== -1 && C.push(m), d !== -1 && C.push(d), h.tonePrefersLightForeground(l) || h.tonePrefersLightForeground(y) ? m < 0 ? 100 : m : C.length === 1 ? C[0] : d < 0 ? 0 : d;
    }
  }
}
class Pe {
  getHct(t, e) {
    const r = e.palette(t), n = e.getTone(t), a = r.hue, i = r.chroma * (e.chromaMultiplier ? e.chromaMultiplier(t) : 1);
    return x.from(a, i, n);
  }
  getTone(t, e) {
    const r = e.toneDeltaPair ? e.toneDeltaPair(t) : void 0;
    if (r) {
      const n = r.roleA, a = r.roleB, i = r.polarity, u = r.constraint, f = i === "darker" || i === "relative_lighter" && t.isDark || i === "relative_darker" && !t.isDark ? -r.delta : r.delta, p = e.name === n.name, l = p ? n : a, y = p ? a : n;
      let P = l.tone(t), g = y.getTone(t);
      const m = f * (p ? 1 : -1);
      if (u === "exact" ? P = Y(0, 100, g + m) : u === "nearer" ? m > 0 ? P = Y(0, 100, Y(g, g + m, P)) : P = Y(0, 100, Y(g + m, g, P)) : u === "farther" && (m > 0 ? P = Y(g + m, 100, P) : P = Y(0, g + m, P)), e.background && e.contrastCurve) {
        const d = e.background(t), C = e.contrastCurve(t);
        if (d && C) {
          const D = d.getTone(t), T = C.get(t.contrastLevel);
          P = H.ratioOfTones(D, P) >= T && t.contrastLevel >= 0 ? P : h.foregroundTone(D, T);
        }
      }
      return e.isBackground && !e.name.endsWith("_fixed_dim") && (P >= 57 ? P = Y(65, 100, P) : P = Y(0, 49, P)), P;
    } else {
      let n = e.tone(t);
      if (e.background == null || e.background(t) === void 0 || e.contrastCurve == null || e.contrastCurve(t) === void 0) return n;
      const a = e.background(t).getTone(t), i = e.contrastCurve(t).get(t.contrastLevel);
      if (n = H.ratioOfTones(a, n) >= i && t.contrastLevel >= 0 ? n : h.foregroundTone(a, i), e.isBackground && !e.name.endsWith("_fixed_dim") && (n >= 57 ? n = Y(65, 100, n) : n = Y(0, 49, n)), e.secondBackground == null || e.secondBackground(t) === void 0) return n;
      const [u, f] = [e.background, e.secondBackground], [p, l] = [u(t).getTone(t), f(t).getTone(t)], [y, P] = [Math.max(p, l), Math.min(p, l)];
      if (H.ratioOfTones(y, n) >= i && H.ratioOfTones(P, n) >= i) return n;
      const g = H.lighter(y, i), m = H.darker(P, i), d = [];
      return g !== -1 && d.push(g), m !== -1 && d.push(m), h.tonePrefersLightForeground(p) || h.tonePrefersLightForeground(l) ? g < 0 ? 100 : g : d.length === 1 ? d[0] : m < 0 ? 0 : m;
    }
  }
}
const Ce = new ye(), Ae = new Pe();
function Zt(o) {
  return o === "2025" ? Ae : Ce;
}
class A {
  static fromInt(t) {
    const e = x.fromInt(t);
    return A.fromHct(e);
  }
  static fromHct(t) {
    return new A(t.hue, t.chroma, t);
  }
  static fromHueAndChroma(t, e) {
    const r = new Te(t, e).create();
    return new A(t, e, r);
  }
  constructor(t, e, r) {
    this.hue = t, this.chroma = e, this.keyColor = r, this.cache = /* @__PURE__ */ new Map();
  }
  tone(t) {
    let e = this.cache.get(t);
    return e === void 0 && (t == 99 && x.isYellow(this.hue) ? e = this.averageArgb(this.tone(98), this.tone(100)) : e = x.from(this.hue, this.chroma, t).toInt(), this.cache.set(t, e)), e;
  }
  getHct(t) {
    return x.fromInt(this.tone(t));
  }
  averageArgb(t, e) {
    const r = t >>> 16 & 255, n = t >>> 8 & 255, a = t & 255, i = e >>> 16 & 255, u = e >>> 8 & 255, f = e & 255, p = Math.round((r + i) / 2), l = Math.round((n + u) / 2), y = Math.round((a + f) / 2);
    return (255 << 24 | (p & 255) << 16 | (l & 255) << 8 | y & 255) >>> 0;
  }
}
class Te {
  constructor(t, e) {
    this.hue = t, this.requestedChroma = e, this.chromaCache = /* @__PURE__ */ new Map(), this.maxChromaValue = 200;
  }
  create() {
    let n = 0, a = 100;
    for (; n < a; ) {
      const i = Math.floor((n + a) / 2), u = this.maxChroma(i) < this.maxChroma(i + 1);
      if (this.maxChroma(i) >= this.requestedChroma - 0.01) if (Math.abs(n - 50) < Math.abs(a - 50)) a = i;
      else {
        if (n === i) return x.from(this.hue, this.requestedChroma, n);
        n = i;
      }
      else u ? n = i + 1 : a = i;
    }
    return x.from(this.hue, this.requestedChroma, n);
  }
  maxChroma(t) {
    if (this.chromaCache.has(t)) return this.chromaCache.get(t);
    const e = x.from(this.hue, this.maxChromaValue, t).chroma;
    return this.chromaCache.set(t, e), e;
  }
}
class ht {
  constructor(t) {
    this.input = t, this.hctsByTempCache = [], this.hctsByHueCache = [], this.tempsByHctCache = /* @__PURE__ */ new Map(), this.inputRelativeTemperatureCache = -1, this.complementCache = null;
  }
  get hctsByTemp() {
    if (this.hctsByTempCache.length > 0) return this.hctsByTempCache;
    const t = this.hctsByHue.concat([this.input]), e = this.tempsByHct;
    return t.sort((r, n) => e.get(r) - e.get(n)), this.hctsByTempCache = t, t;
  }
  get warmest() {
    return this.hctsByTemp[this.hctsByTemp.length - 1];
  }
  get coldest() {
    return this.hctsByTemp[0];
  }
  analogous(t = 5, e = 12) {
    const r = Math.round(this.input.hue), n = this.hctsByHue[r];
    let a = this.relativeTemperature(n);
    const i = [n];
    let u = 0;
    for (let m = 0; m < 360; m++) {
      const d = pt(r + m), C = this.hctsByHue[d], D = this.relativeTemperature(C), T = Math.abs(D - a);
      a = D, u += T;
    }
    let f = 1;
    const p = u / e;
    let l = 0;
    for (a = this.relativeTemperature(n); i.length < e; ) {
      const m = pt(r + f), d = this.hctsByHue[m], C = this.relativeTemperature(d), D = Math.abs(C - a);
      l += D;
      const T = i.length * p;
      let b = l >= T, B = 1;
      for (; b && i.length < e; ) {
        i.push(d);
        const L = (i.length + B) * p;
        b = l >= L, B++;
      }
      if (a = C, f++, f > 360) {
        for (; i.length < e; ) i.push(d);
        break;
      }
    }
    const y = [this.input], P = Math.floor((t - 1) / 2);
    for (let m = 1; m < P + 1; m++) {
      let d = 0 - m;
      for (; d < 0; ) d = i.length + d;
      d >= i.length && (d = d % i.length), y.splice(0, 0, i[d]);
    }
    const g = t - P - 1;
    for (let m = 1; m < g + 1; m++) {
      let d = m;
      for (; d < 0; ) d = i.length + d;
      d >= i.length && (d = d % i.length), y.push(i[d]);
    }
    return y;
  }
  get complement() {
    if (this.complementCache != null) return this.complementCache;
    const t = this.coldest.hue, e = this.tempsByHct.get(this.coldest), r = this.warmest.hue, a = this.tempsByHct.get(this.warmest) - e, i = ht.isBetween(this.input.hue, t, r), u = i ? r : t, f = i ? t : r, p = 1;
    let l = 1e3, y = this.hctsByHue[Math.round(this.input.hue)];
    const P = 1 - this.inputRelativeTemperature;
    for (let g = 0; g <= 360; g += 1) {
      const m = K(u + p * g);
      if (!ht.isBetween(m, u, f)) continue;
      const d = this.hctsByHue[Math.round(m)], C = (this.tempsByHct.get(d) - e) / a, D = Math.abs(P - C);
      D < l && (l = D, y = d);
    }
    return this.complementCache = y, this.complementCache;
  }
  relativeTemperature(t) {
    const e = this.tempsByHct.get(this.warmest) - this.tempsByHct.get(this.coldest), r = this.tempsByHct.get(t) - this.tempsByHct.get(this.coldest);
    return e === 0 ? 0.5 : r / e;
  }
  get inputRelativeTemperature() {
    return this.inputRelativeTemperatureCache >= 0 ? this.inputRelativeTemperatureCache : (this.inputRelativeTemperatureCache = this.relativeTemperature(this.input), this.inputRelativeTemperatureCache);
  }
  get tempsByHct() {
    if (this.tempsByHctCache.size > 0) return this.tempsByHctCache;
    const t = this.hctsByHue.concat([this.input]), e = /* @__PURE__ */ new Map();
    for (const r of t) e.set(r, ht.rawTemperature(r));
    return this.tempsByHctCache = e, e;
  }
  get hctsByHue() {
    if (this.hctsByHueCache.length > 0) return this.hctsByHueCache;
    const t = [];
    for (let e = 0; e <= 360; e += 1) {
      const r = x.from(e, this.input.chroma, this.input.tone);
      t.push(r);
    }
    return this.hctsByHueCache = t, this.hctsByHueCache;
  }
  static isBetween(t, e, r) {
    return e < r ? e <= t && t <= r : e <= t || t <= r;
  }
  static rawTemperature(t) {
    const e = _t(t.toInt()), r = K(Math.atan2(e[2], e[1]) * 180 / Math.PI), n = Math.sqrt(e[1] * e[1] + e[2] * e[2]);
    return -0.5 + 0.02 * Math.pow(n, 1.07) * Math.cos(K(r - 50) * Math.PI / 180);
  }
}
class k {
  constructor(t, e, r, n) {
    this.low = t, this.normal = e, this.medium = r, this.high = n;
  }
  get(t) {
    return t <= -1 ? this.low : t < 0 ? lt(this.low, this.normal, (t - -1) / 1) : t < 0.5 ? lt(this.normal, this.medium, (t - 0) / 0.5) : t < 1 ? lt(this.medium, this.high, (t - 0.5) / 0.5) : this.high;
  }
}
class V {
  constructor(t, e, r, n, a, i) {
    this.roleA = t, this.roleB = e, this.delta = r, this.polarity = n, this.stayTogether = a, this.constraint = i, this.constraint = i != null ? i : "exact";
  }
}
var c;
(function(o) {
  o[o.MONOCHROME = 0] = "MONOCHROME", o[o.NEUTRAL = 1] = "NEUTRAL", o[o.TONAL_SPOT = 2] = "TONAL_SPOT", o[o.VIBRANT = 3] = "VIBRANT", o[o.EXPRESSIVE = 4] = "EXPRESSIVE", o[o.FIDELITY = 5] = "FIDELITY", o[o.CONTENT = 6] = "CONTENT", o[o.RAINBOW = 7] = "RAINBOW", o[o.FRUIT_SALAD = 8] = "FRUIT_SALAD";
})(c || (c = {}));
function ft(o) {
  return o.variant === c.FIDELITY || o.variant === c.CONTENT;
}
function _(o) {
  return o.variant === c.MONOCHROME;
}
function Se(o, t, e, r) {
  let n = e, a = x.from(o, t, e);
  if (a.chroma < t) {
    let i = a.chroma;
    for (; a.chroma < t; ) {
      n += r ? -1 : 1;
      const u = x.from(o, t, n);
      if (i > u.chroma || Math.abs(u.chroma - t) < 0.4) break;
      const f = Math.abs(u.chroma - t), p = Math.abs(a.chroma - t);
      f < p && (a = u), i = Math.max(i, u.chroma);
    }
  }
  return n;
}
class ke {
  primaryPaletteKeyColor() {
    return h.fromPalette({ name: "primary_palette_key_color", palette: (t) => t.primaryPalette, tone: (t) => t.primaryPalette.keyColor.tone });
  }
  secondaryPaletteKeyColor() {
    return h.fromPalette({ name: "secondary_palette_key_color", palette: (t) => t.secondaryPalette, tone: (t) => t.secondaryPalette.keyColor.tone });
  }
  tertiaryPaletteKeyColor() {
    return h.fromPalette({ name: "tertiary_palette_key_color", palette: (t) => t.tertiaryPalette, tone: (t) => t.tertiaryPalette.keyColor.tone });
  }
  neutralPaletteKeyColor() {
    return h.fromPalette({ name: "neutral_palette_key_color", palette: (t) => t.neutralPalette, tone: (t) => t.neutralPalette.keyColor.tone });
  }
  neutralVariantPaletteKeyColor() {
    return h.fromPalette({ name: "neutral_variant_palette_key_color", palette: (t) => t.neutralVariantPalette, tone: (t) => t.neutralVariantPalette.keyColor.tone });
  }
  errorPaletteKeyColor() {
    return h.fromPalette({ name: "error_palette_key_color", palette: (t) => t.errorPalette, tone: (t) => t.errorPalette.keyColor.tone });
  }
  background() {
    return h.fromPalette({ name: "background", palette: (t) => t.neutralPalette, tone: (t) => t.isDark ? 6 : 98, isBackground: true });
  }
  onBackground() {
    return h.fromPalette({ name: "on_background", palette: (t) => t.neutralPalette, tone: (t) => t.isDark ? 90 : 10, background: (t) => this.background(), contrastCurve: (t) => new k(3, 3, 4.5, 7) });
  }
  surface() {
    return h.fromPalette({ name: "surface", palette: (t) => t.neutralPalette, tone: (t) => t.isDark ? 6 : 98, isBackground: true });
  }
  surfaceDim() {
    return h.fromPalette({ name: "surface_dim", palette: (t) => t.neutralPalette, tone: (t) => t.isDark ? 6 : new k(87, 87, 80, 75).get(t.contrastLevel), isBackground: true });
  }
  surfaceBright() {
    return h.fromPalette({ name: "surface_bright", palette: (t) => t.neutralPalette, tone: (t) => t.isDark ? new k(24, 24, 29, 34).get(t.contrastLevel) : 98, isBackground: true });
  }
  surfaceContainerLowest() {
    return h.fromPalette({ name: "surface_container_lowest", palette: (t) => t.neutralPalette, tone: (t) => t.isDark ? new k(4, 4, 2, 0).get(t.contrastLevel) : 100, isBackground: true });
  }
  surfaceContainerLow() {
    return h.fromPalette({ name: "surface_container_low", palette: (t) => t.neutralPalette, tone: (t) => t.isDark ? new k(10, 10, 11, 12).get(t.contrastLevel) : new k(96, 96, 96, 95).get(t.contrastLevel), isBackground: true });
  }
  surfaceContainer() {
    return h.fromPalette({ name: "surface_container", palette: (t) => t.neutralPalette, tone: (t) => t.isDark ? new k(12, 12, 16, 20).get(t.contrastLevel) : new k(94, 94, 92, 90).get(t.contrastLevel), isBackground: true });
  }
  surfaceContainerHigh() {
    return h.fromPalette({ name: "surface_container_high", palette: (t) => t.neutralPalette, tone: (t) => t.isDark ? new k(17, 17, 21, 25).get(t.contrastLevel) : new k(92, 92, 88, 85).get(t.contrastLevel), isBackground: true });
  }
  surfaceContainerHighest() {
    return h.fromPalette({ name: "surface_container_highest", palette: (t) => t.neutralPalette, tone: (t) => t.isDark ? new k(22, 22, 26, 30).get(t.contrastLevel) : new k(90, 90, 84, 80).get(t.contrastLevel), isBackground: true });
  }
  onSurface() {
    return h.fromPalette({ name: "on_surface", palette: (t) => t.neutralPalette, tone: (t) => t.isDark ? 90 : 10, background: (t) => this.highestSurface(t), contrastCurve: (t) => new k(4.5, 7, 11, 21) });
  }
  surfaceVariant() {
    return h.fromPalette({ name: "surface_variant", palette: (t) => t.neutralVariantPalette, tone: (t) => t.isDark ? 30 : 90, isBackground: true });
  }
  onSurfaceVariant() {
    return h.fromPalette({ name: "on_surface_variant", palette: (t) => t.neutralVariantPalette, tone: (t) => t.isDark ? 80 : 30, background: (t) => this.highestSurface(t), contrastCurve: (t) => new k(3, 4.5, 7, 11) });
  }
  inverseSurface() {
    return h.fromPalette({ name: "inverse_surface", palette: (t) => t.neutralPalette, tone: (t) => t.isDark ? 90 : 20, isBackground: true });
  }
  inverseOnSurface() {
    return h.fromPalette({ name: "inverse_on_surface", palette: (t) => t.neutralPalette, tone: (t) => t.isDark ? 20 : 95, background: (t) => this.inverseSurface(), contrastCurve: (t) => new k(4.5, 7, 11, 21) });
  }
  outline() {
    return h.fromPalette({ name: "outline", palette: (t) => t.neutralVariantPalette, tone: (t) => t.isDark ? 60 : 50, background: (t) => this.highestSurface(t), contrastCurve: (t) => new k(1.5, 3, 4.5, 7) });
  }
  outlineVariant() {
    return h.fromPalette({ name: "outline_variant", palette: (t) => t.neutralVariantPalette, tone: (t) => t.isDark ? 30 : 80, background: (t) => this.highestSurface(t), contrastCurve: (t) => new k(1, 1, 3, 4.5) });
  }
  shadow() {
    return h.fromPalette({ name: "shadow", palette: (t) => t.neutralPalette, tone: (t) => 0 });
  }
  scrim() {
    return h.fromPalette({ name: "scrim", palette: (t) => t.neutralPalette, tone: (t) => 0 });
  }
  surfaceTint() {
    return h.fromPalette({ name: "surface_tint", palette: (t) => t.primaryPalette, tone: (t) => t.isDark ? 80 : 40, isBackground: true });
  }
  primary() {
    return h.fromPalette({ name: "primary", palette: (t) => t.primaryPalette, tone: (t) => _(t) ? t.isDark ? 100 : 0 : t.isDark ? 80 : 40, isBackground: true, background: (t) => this.highestSurface(t), contrastCurve: (t) => new k(3, 4.5, 7, 7), toneDeltaPair: (t) => new V(this.primaryContainer(), this.primary(), 10, "nearer", false) });
  }
  primaryDim() {
  }
  onPrimary() {
    return h.fromPalette({ name: "on_primary", palette: (t) => t.primaryPalette, tone: (t) => _(t) ? t.isDark ? 10 : 90 : t.isDark ? 20 : 100, background: (t) => this.primary(), contrastCurve: (t) => new k(4.5, 7, 11, 21) });
  }
  primaryContainer() {
    return h.fromPalette({ name: "primary_container", palette: (t) => t.primaryPalette, tone: (t) => ft(t) ? t.sourceColorHct.tone : _(t) ? t.isDark ? 85 : 25 : t.isDark ? 30 : 90, isBackground: true, background: (t) => this.highestSurface(t), contrastCurve: (t) => new k(1, 1, 3, 4.5), toneDeltaPair: (t) => new V(this.primaryContainer(), this.primary(), 10, "nearer", false) });
  }
  onPrimaryContainer() {
    return h.fromPalette({ name: "on_primary_container", palette: (t) => t.primaryPalette, tone: (t) => ft(t) ? h.foregroundTone(this.primaryContainer().tone(t), 4.5) : _(t) ? t.isDark ? 0 : 100 : t.isDark ? 90 : 30, background: (t) => this.primaryContainer(), contrastCurve: (t) => new k(3, 4.5, 7, 11) });
  }
  inversePrimary() {
    return h.fromPalette({ name: "inverse_primary", palette: (t) => t.primaryPalette, tone: (t) => t.isDark ? 40 : 80, background: (t) => this.inverseSurface(), contrastCurve: (t) => new k(3, 4.5, 7, 7) });
  }
  secondary() {
    return h.fromPalette({ name: "secondary", palette: (t) => t.secondaryPalette, tone: (t) => t.isDark ? 80 : 40, isBackground: true, background: (t) => this.highestSurface(t), contrastCurve: (t) => new k(3, 4.5, 7, 7), toneDeltaPair: (t) => new V(this.secondaryContainer(), this.secondary(), 10, "nearer", false) });
  }
  secondaryDim() {
  }
  onSecondary() {
    return h.fromPalette({ name: "on_secondary", palette: (t) => t.secondaryPalette, tone: (t) => _(t) ? t.isDark ? 10 : 100 : t.isDark ? 20 : 100, background: (t) => this.secondary(), contrastCurve: (t) => new k(4.5, 7, 11, 21) });
  }
  secondaryContainer() {
    return h.fromPalette({ name: "secondary_container", palette: (t) => t.secondaryPalette, tone: (t) => {
      const e = t.isDark ? 30 : 90;
      return _(t) ? t.isDark ? 30 : 85 : ft(t) ? Se(t.secondaryPalette.hue, t.secondaryPalette.chroma, e, !t.isDark) : e;
    }, isBackground: true, background: (t) => this.highestSurface(t), contrastCurve: (t) => new k(1, 1, 3, 4.5), toneDeltaPair: (t) => new V(this.secondaryContainer(), this.secondary(), 10, "nearer", false) });
  }
  onSecondaryContainer() {
    return h.fromPalette({ name: "on_secondary_container", palette: (t) => t.secondaryPalette, tone: (t) => _(t) ? t.isDark ? 90 : 10 : ft(t) ? h.foregroundTone(this.secondaryContainer().tone(t), 4.5) : t.isDark ? 90 : 30, background: (t) => this.secondaryContainer(), contrastCurve: (t) => new k(3, 4.5, 7, 11) });
  }
  tertiary() {
    return h.fromPalette({ name: "tertiary", palette: (t) => t.tertiaryPalette, tone: (t) => _(t) ? t.isDark ? 90 : 25 : t.isDark ? 80 : 40, isBackground: true, background: (t) => this.highestSurface(t), contrastCurve: (t) => new k(3, 4.5, 7, 7), toneDeltaPair: (t) => new V(this.tertiaryContainer(), this.tertiary(), 10, "nearer", false) });
  }
  tertiaryDim() {
  }
  onTertiary() {
    return h.fromPalette({ name: "on_tertiary", palette: (t) => t.tertiaryPalette, tone: (t) => _(t) ? t.isDark ? 10 : 90 : t.isDark ? 20 : 100, background: (t) => this.tertiary(), contrastCurve: (t) => new k(4.5, 7, 11, 21) });
  }
  tertiaryContainer() {
    return h.fromPalette({ name: "tertiary_container", palette: (t) => t.tertiaryPalette, tone: (t) => {
      if (_(t)) return t.isDark ? 60 : 49;
      if (!ft(t)) return t.isDark ? 30 : 90;
      const e = t.tertiaryPalette.getHct(t.sourceColorHct.tone);
      return mt.fixIfDisliked(e).tone;
    }, isBackground: true, background: (t) => this.highestSurface(t), contrastCurve: (t) => new k(1, 1, 3, 4.5), toneDeltaPair: (t) => new V(this.tertiaryContainer(), this.tertiary(), 10, "nearer", false) });
  }
  onTertiaryContainer() {
    return h.fromPalette({ name: "on_tertiary_container", palette: (t) => t.tertiaryPalette, tone: (t) => _(t) ? t.isDark ? 0 : 100 : ft(t) ? h.foregroundTone(this.tertiaryContainer().tone(t), 4.5) : t.isDark ? 90 : 30, background: (t) => this.tertiaryContainer(), contrastCurve: (t) => new k(3, 4.5, 7, 11) });
  }
  error() {
    return h.fromPalette({ name: "error", palette: (t) => t.errorPalette, tone: (t) => t.isDark ? 80 : 40, isBackground: true, background: (t) => this.highestSurface(t), contrastCurve: (t) => new k(3, 4.5, 7, 7), toneDeltaPair: (t) => new V(this.errorContainer(), this.error(), 10, "nearer", false) });
  }
  errorDim() {
  }
  onError() {
    return h.fromPalette({ name: "on_error", palette: (t) => t.errorPalette, tone: (t) => t.isDark ? 20 : 100, background: (t) => this.error(), contrastCurve: (t) => new k(4.5, 7, 11, 21) });
  }
  errorContainer() {
    return h.fromPalette({ name: "error_container", palette: (t) => t.errorPalette, tone: (t) => t.isDark ? 30 : 90, isBackground: true, background: (t) => this.highestSurface(t), contrastCurve: (t) => new k(1, 1, 3, 4.5), toneDeltaPair: (t) => new V(this.errorContainer(), this.error(), 10, "nearer", false) });
  }
  onErrorContainer() {
    return h.fromPalette({ name: "on_error_container", palette: (t) => t.errorPalette, tone: (t) => _(t) ? t.isDark ? 90 : 10 : t.isDark ? 90 : 30, background: (t) => this.errorContainer(), contrastCurve: (t) => new k(3, 4.5, 7, 11) });
  }
  primaryFixed() {
    return h.fromPalette({ name: "primary_fixed", palette: (t) => t.primaryPalette, tone: (t) => _(t) ? 40 : 90, isBackground: true, background: (t) => this.highestSurface(t), contrastCurve: (t) => new k(1, 1, 3, 4.5), toneDeltaPair: (t) => new V(this.primaryFixed(), this.primaryFixedDim(), 10, "lighter", true) });
  }
  primaryFixedDim() {
    return h.fromPalette({ name: "primary_fixed_dim", palette: (t) => t.primaryPalette, tone: (t) => _(t) ? 30 : 80, isBackground: true, background: (t) => this.highestSurface(t), contrastCurve: (t) => new k(1, 1, 3, 4.5), toneDeltaPair: (t) => new V(this.primaryFixed(), this.primaryFixedDim(), 10, "lighter", true) });
  }
  onPrimaryFixed() {
    return h.fromPalette({ name: "on_primary_fixed", palette: (t) => t.primaryPalette, tone: (t) => _(t) ? 100 : 10, background: (t) => this.primaryFixedDim(), secondBackground: (t) => this.primaryFixed(), contrastCurve: (t) => new k(4.5, 7, 11, 21) });
  }
  onPrimaryFixedVariant() {
    return h.fromPalette({ name: "on_primary_fixed_variant", palette: (t) => t.primaryPalette, tone: (t) => _(t) ? 90 : 30, background: (t) => this.primaryFixedDim(), secondBackground: (t) => this.primaryFixed(), contrastCurve: (t) => new k(3, 4.5, 7, 11) });
  }
  secondaryFixed() {
    return h.fromPalette({ name: "secondary_fixed", palette: (t) => t.secondaryPalette, tone: (t) => _(t) ? 80 : 90, isBackground: true, background: (t) => this.highestSurface(t), contrastCurve: (t) => new k(1, 1, 3, 4.5), toneDeltaPair: (t) => new V(this.secondaryFixed(), this.secondaryFixedDim(), 10, "lighter", true) });
  }
  secondaryFixedDim() {
    return h.fromPalette({ name: "secondary_fixed_dim", palette: (t) => t.secondaryPalette, tone: (t) => _(t) ? 70 : 80, isBackground: true, background: (t) => this.highestSurface(t), contrastCurve: (t) => new k(1, 1, 3, 4.5), toneDeltaPair: (t) => new V(this.secondaryFixed(), this.secondaryFixedDim(), 10, "lighter", true) });
  }
  onSecondaryFixed() {
    return h.fromPalette({ name: "on_secondary_fixed", palette: (t) => t.secondaryPalette, tone: (t) => 10, background: (t) => this.secondaryFixedDim(), secondBackground: (t) => this.secondaryFixed(), contrastCurve: (t) => new k(4.5, 7, 11, 21) });
  }
  onSecondaryFixedVariant() {
    return h.fromPalette({ name: "on_secondary_fixed_variant", palette: (t) => t.secondaryPalette, tone: (t) => _(t) ? 25 : 30, background: (t) => this.secondaryFixedDim(), secondBackground: (t) => this.secondaryFixed(), contrastCurve: (t) => new k(3, 4.5, 7, 11) });
  }
  tertiaryFixed() {
    return h.fromPalette({ name: "tertiary_fixed", palette: (t) => t.tertiaryPalette, tone: (t) => _(t) ? 40 : 90, isBackground: true, background: (t) => this.highestSurface(t), contrastCurve: (t) => new k(1, 1, 3, 4.5), toneDeltaPair: (t) => new V(this.tertiaryFixed(), this.tertiaryFixedDim(), 10, "lighter", true) });
  }
  tertiaryFixedDim() {
    return h.fromPalette({ name: "tertiary_fixed_dim", palette: (t) => t.tertiaryPalette, tone: (t) => _(t) ? 30 : 80, isBackground: true, background: (t) => this.highestSurface(t), contrastCurve: (t) => new k(1, 1, 3, 4.5), toneDeltaPair: (t) => new V(this.tertiaryFixed(), this.tertiaryFixedDim(), 10, "lighter", true) });
  }
  onTertiaryFixed() {
    return h.fromPalette({ name: "on_tertiary_fixed", palette: (t) => t.tertiaryPalette, tone: (t) => _(t) ? 100 : 10, background: (t) => this.tertiaryFixedDim(), secondBackground: (t) => this.tertiaryFixed(), contrastCurve: (t) => new k(4.5, 7, 11, 21) });
  }
  onTertiaryFixedVariant() {
    return h.fromPalette({ name: "on_tertiary_fixed_variant", palette: (t) => t.tertiaryPalette, tone: (t) => _(t) ? 90 : 30, background: (t) => this.tertiaryFixedDim(), secondBackground: (t) => this.tertiaryFixed(), contrastCurve: (t) => new k(3, 4.5, 7, 11) });
  }
  highestSurface(t) {
    return t.isDark ? this.surfaceBright() : this.surfaceDim();
  }
}
function R(o, t = 0, e = 100, r = 1) {
  let n = te(o.hue, o.chroma * r, 100, true);
  return Y(t, e, n);
}
function st(o, t = 0, e = 100) {
  let r = te(o.hue, o.chroma, 0, false);
  return Y(t, e, r);
}
function te(o, t, e, r) {
  let n = e, a = x.from(o, t, n);
  for (; a.chroma < t && !(e < 0 || e > 100); ) {
    e += r ? -1 : 1;
    const i = x.from(o, t, e);
    a.chroma < i.chroma && (a = i, n = e);
  }
  return n;
}
function w(o) {
  return o === 1.5 ? new k(1.5, 1.5, 3, 5.5) : o === 3 ? new k(3, 3, 4.5, 7) : o === 4.5 ? new k(4.5, 4.5, 7, 11) : o === 6 ? new k(6, 6, 7, 11) : o === 7 ? new k(7, 7, 11, 21) : o === 9 ? new k(9, 9, 11, 21) : o === 11 ? new k(11, 11, 21, 21) : o === 21 ? new k(21, 21, 21, 21) : new k(o, o, 7, 21);
}
class xe extends ke {
  surface() {
    const t = h.fromPalette({ name: "surface", palette: (e) => e.neutralPalette, tone: (e) => (super.surface().tone(e), e.platform === "phone" ? e.isDark ? 4 : x.isYellow(e.neutralPalette.hue) ? 99 : e.variant === c.VIBRANT ? 97 : 98 : 0), isBackground: true });
    return F(super.surface(), "2025", t);
  }
  surfaceDim() {
    const t = h.fromPalette({ name: "surface_dim", palette: (e) => e.neutralPalette, tone: (e) => e.isDark ? 4 : x.isYellow(e.neutralPalette.hue) ? 90 : e.variant === c.VIBRANT ? 85 : 87, isBackground: true, chromaMultiplier: (e) => {
      if (!e.isDark) {
        if (e.variant === c.NEUTRAL) return 2.5;
        if (e.variant === c.TONAL_SPOT) return 1.7;
        if (e.variant === c.EXPRESSIVE) return x.isYellow(e.neutralPalette.hue) ? 2.7 : 1.75;
        if (e.variant === c.VIBRANT) return 1.36;
      }
      return 1;
    } });
    return F(super.surfaceDim(), "2025", t);
  }
  surfaceBright() {
    const t = h.fromPalette({ name: "surface_bright", palette: (e) => e.neutralPalette, tone: (e) => e.isDark ? 18 : x.isYellow(e.neutralPalette.hue) ? 99 : e.variant === c.VIBRANT ? 97 : 98, isBackground: true, chromaMultiplier: (e) => {
      if (e.isDark) {
        if (e.variant === c.NEUTRAL) return 2.5;
        if (e.variant === c.TONAL_SPOT) return 1.7;
        if (e.variant === c.EXPRESSIVE) return x.isYellow(e.neutralPalette.hue) ? 2.7 : 1.75;
        if (e.variant === c.VIBRANT) return 1.36;
      }
      return 1;
    } });
    return F(super.surfaceBright(), "2025", t);
  }
  surfaceContainerLowest() {
    const t = h.fromPalette({ name: "surface_container_lowest", palette: (e) => e.neutralPalette, tone: (e) => e.isDark ? 0 : 100, isBackground: true });
    return F(super.surfaceContainerLowest(), "2025", t);
  }
  surfaceContainerLow() {
    const t = h.fromPalette({ name: "surface_container_low", palette: (e) => e.neutralPalette, tone: (e) => e.platform === "phone" ? e.isDark ? 6 : x.isYellow(e.neutralPalette.hue) ? 98 : e.variant === c.VIBRANT ? 95 : 96 : 15, isBackground: true, chromaMultiplier: (e) => {
      if (e.platform === "phone") {
        if (e.variant === c.NEUTRAL) return 1.3;
        if (e.variant === c.TONAL_SPOT) return 1.25;
        if (e.variant === c.EXPRESSIVE) return x.isYellow(e.neutralPalette.hue) ? 1.3 : 1.15;
        if (e.variant === c.VIBRANT) return 1.08;
      }
      return 1;
    } });
    return F(super.surfaceContainerLow(), "2025", t);
  }
  surfaceContainer() {
    const t = h.fromPalette({ name: "surface_container", palette: (e) => e.neutralPalette, tone: (e) => e.platform === "phone" ? e.isDark ? 9 : x.isYellow(e.neutralPalette.hue) ? 96 : e.variant === c.VIBRANT ? 92 : 94 : 20, isBackground: true, chromaMultiplier: (e) => {
      if (e.platform === "phone") {
        if (e.variant === c.NEUTRAL) return 1.6;
        if (e.variant === c.TONAL_SPOT) return 1.4;
        if (e.variant === c.EXPRESSIVE) return x.isYellow(e.neutralPalette.hue) ? 1.6 : 1.3;
        if (e.variant === c.VIBRANT) return 1.15;
      }
      return 1;
    } });
    return F(super.surfaceContainer(), "2025", t);
  }
  surfaceContainerHigh() {
    const t = h.fromPalette({ name: "surface_container_high", palette: (e) => e.neutralPalette, tone: (e) => e.platform === "phone" ? e.isDark ? 12 : x.isYellow(e.neutralPalette.hue) ? 94 : e.variant === c.VIBRANT ? 90 : 92 : 25, isBackground: true, chromaMultiplier: (e) => {
      if (e.platform === "phone") {
        if (e.variant === c.NEUTRAL) return 1.9;
        if (e.variant === c.TONAL_SPOT) return 1.5;
        if (e.variant === c.EXPRESSIVE) return x.isYellow(e.neutralPalette.hue) ? 1.95 : 1.45;
        if (e.variant === c.VIBRANT) return 1.22;
      }
      return 1;
    } });
    return F(super.surfaceContainerHigh(), "2025", t);
  }
  surfaceContainerHighest() {
    const t = h.fromPalette({ name: "surface_container_highest", palette: (e) => e.neutralPalette, tone: (e) => e.isDark ? 15 : x.isYellow(e.neutralPalette.hue) ? 92 : e.variant === c.VIBRANT ? 88 : 90, isBackground: true, chromaMultiplier: (e) => e.variant === c.NEUTRAL ? 2.2 : e.variant === c.TONAL_SPOT ? 1.7 : e.variant === c.EXPRESSIVE ? x.isYellow(e.neutralPalette.hue) ? 2.3 : 1.6 : e.variant === c.VIBRANT ? 1.29 : 1 });
    return F(super.surfaceContainerHighest(), "2025", t);
  }
  onSurface() {
    const t = h.fromPalette({ name: "on_surface", palette: (e) => e.neutralPalette, tone: (e) => e.variant === c.VIBRANT ? R(e.neutralPalette, 0, 100, 1.1) : h.getInitialToneFromBackground((r) => r.platform === "phone" ? this.highestSurface(r) : this.surfaceContainerHigh())(e), chromaMultiplier: (e) => {
      if (e.platform === "phone") {
        if (e.variant === c.NEUTRAL) return 2.2;
        if (e.variant === c.TONAL_SPOT) return 1.7;
        if (e.variant === c.EXPRESSIVE) return x.isYellow(e.neutralPalette.hue) ? e.isDark ? 3 : 2.3 : 1.6;
      }
      return 1;
    }, background: (e) => e.platform === "phone" ? this.highestSurface(e) : this.surfaceContainerHigh(), contrastCurve: (e) => e.isDark && e.platform === "phone" ? w(11) : w(9) });
    return F(super.onSurface(), "2025", t);
  }
  onSurfaceVariant() {
    const t = h.fromPalette({ name: "on_surface_variant", palette: (e) => e.neutralPalette, chromaMultiplier: (e) => {
      if (e.platform === "phone") {
        if (e.variant === c.NEUTRAL) return 2.2;
        if (e.variant === c.TONAL_SPOT) return 1.7;
        if (e.variant === c.EXPRESSIVE) return x.isYellow(e.neutralPalette.hue) ? e.isDark ? 3 : 2.3 : 1.6;
      }
      return 1;
    }, background: (e) => e.platform === "phone" ? this.highestSurface(e) : this.surfaceContainerHigh(), contrastCurve: (e) => e.platform === "phone" ? e.isDark ? w(6) : w(4.5) : w(7) });
    return F(super.onSurfaceVariant(), "2025", t);
  }
  outline() {
    const t = h.fromPalette({ name: "outline", palette: (e) => e.neutralPalette, chromaMultiplier: (e) => {
      if (e.platform === "phone") {
        if (e.variant === c.NEUTRAL) return 2.2;
        if (e.variant === c.TONAL_SPOT) return 1.7;
        if (e.variant === c.EXPRESSIVE) return x.isYellow(e.neutralPalette.hue) ? e.isDark ? 3 : 2.3 : 1.6;
      }
      return 1;
    }, background: (e) => e.platform === "phone" ? this.highestSurface(e) : this.surfaceContainerHigh(), contrastCurve: (e) => e.platform === "phone" ? w(3) : w(4.5) });
    return F(super.outline(), "2025", t);
  }
  outlineVariant() {
    const t = h.fromPalette({ name: "outline_variant", palette: (e) => e.neutralPalette, chromaMultiplier: (e) => {
      if (e.platform === "phone") {
        if (e.variant === c.NEUTRAL) return 2.2;
        if (e.variant === c.TONAL_SPOT) return 1.7;
        if (e.variant === c.EXPRESSIVE) return x.isYellow(e.neutralPalette.hue) ? e.isDark ? 3 : 2.3 : 1.6;
      }
      return 1;
    }, background: (e) => e.platform === "phone" ? this.highestSurface(e) : this.surfaceContainerHigh(), contrastCurve: (e) => e.platform === "phone" ? w(1.5) : w(3) });
    return F(super.outlineVariant(), "2025", t);
  }
  inverseSurface() {
    const t = h.fromPalette({ name: "inverse_surface", palette: (e) => e.neutralPalette, tone: (e) => e.isDark ? 98 : 4, isBackground: true });
    return F(super.inverseSurface(), "2025", t);
  }
  inverseOnSurface() {
    const t = h.fromPalette({ name: "inverse_on_surface", palette: (e) => e.neutralPalette, background: (e) => this.inverseSurface(), contrastCurve: (e) => w(7) });
    return F(super.inverseOnSurface(), "2025", t);
  }
  primary() {
    const t = h.fromPalette({ name: "primary", palette: (e) => e.primaryPalette, tone: (e) => e.variant === c.NEUTRAL ? e.platform === "phone" ? e.isDark ? 80 : 40 : 90 : e.variant === c.TONAL_SPOT ? e.platform === "phone" ? e.isDark ? 80 : R(e.primaryPalette) : R(e.primaryPalette, 0, 90) : e.variant === c.EXPRESSIVE ? e.platform === "phone" ? R(e.primaryPalette, 0, x.isYellow(e.primaryPalette.hue) ? 25 : x.isCyan(e.primaryPalette.hue) ? 88 : 98) : R(e.primaryPalette) : e.platform === "phone" ? R(e.primaryPalette, 0, x.isCyan(e.primaryPalette.hue) ? 88 : 98) : R(e.primaryPalette), isBackground: true, background: (e) => e.platform === "phone" ? this.highestSurface(e) : this.surfaceContainerHigh(), contrastCurve: (e) => e.platform === "phone" ? w(4.5) : w(7), toneDeltaPair: (e) => e.platform === "phone" ? new V(this.primaryContainer(), this.primary(), 5, "relative_lighter", true, "farther") : void 0 });
    return F(super.primary(), "2025", t);
  }
  primaryDim() {
    return h.fromPalette({ name: "primary_dim", palette: (t) => t.primaryPalette, tone: (t) => t.variant === c.NEUTRAL ? 85 : t.variant === c.TONAL_SPOT ? R(t.primaryPalette, 0, 90) : R(t.primaryPalette), isBackground: true, background: (t) => this.surfaceContainerHigh(), contrastCurve: (t) => w(4.5), toneDeltaPair: (t) => new V(this.primaryDim(), this.primary(), 5, "darker", true, "farther") });
  }
  onPrimary() {
    const t = h.fromPalette({ name: "on_primary", palette: (e) => e.primaryPalette, background: (e) => e.platform === "phone" ? this.primary() : this.primaryDim(), contrastCurve: (e) => e.platform === "phone" ? w(6) : w(7) });
    return F(super.onPrimary(), "2025", t);
  }
  primaryContainer() {
    const t = h.fromPalette({ name: "primary_container", palette: (e) => e.primaryPalette, tone: (e) => e.platform === "watch" ? 30 : e.variant === c.NEUTRAL ? e.isDark ? 30 : 90 : e.variant === c.TONAL_SPOT ? e.isDark ? st(e.primaryPalette, 35, 93) : R(e.primaryPalette, 0, 90) : e.variant === c.EXPRESSIVE ? e.isDark ? R(e.primaryPalette, 30, 93) : R(e.primaryPalette, 78, x.isCyan(e.primaryPalette.hue) ? 88 : 90) : e.isDark ? st(e.primaryPalette, 66, 93) : R(e.primaryPalette, 66, x.isCyan(e.primaryPalette.hue) ? 88 : 93), isBackground: true, background: (e) => e.platform === "phone" ? this.highestSurface(e) : void 0, toneDeltaPair: (e) => e.platform === "phone" ? void 0 : new V(this.primaryContainer(), this.primaryDim(), 10, "darker", true, "farther"), contrastCurve: (e) => e.platform === "phone" && e.contrastLevel > 0 ? w(1.5) : void 0 });
    return F(super.primaryContainer(), "2025", t);
  }
  onPrimaryContainer() {
    const t = h.fromPalette({ name: "on_primary_container", palette: (e) => e.primaryPalette, background: (e) => this.primaryContainer(), contrastCurve: (e) => e.platform === "phone" ? w(6) : w(7) });
    return F(super.onPrimaryContainer(), "2025", t);
  }
  primaryFixed() {
    const t = h.fromPalette({ name: "primary_fixed", palette: (e) => e.primaryPalette, tone: (e) => {
      let r = Object.assign({}, e, { isDark: false, contrastLevel: 0 });
      return this.primaryContainer().getTone(r);
    }, isBackground: true, background: (e) => e.platform === "phone" ? this.highestSurface(e) : void 0, contrastCurve: (e) => e.platform === "phone" && e.contrastLevel > 0 ? w(1.5) : void 0 });
    return F(super.primaryFixed(), "2025", t);
  }
  primaryFixedDim() {
    const t = h.fromPalette({ name: "primary_fixed_dim", palette: (e) => e.primaryPalette, tone: (e) => this.primaryFixed().getTone(e), isBackground: true, toneDeltaPair: (e) => new V(this.primaryFixedDim(), this.primaryFixed(), 5, "darker", true, "exact") });
    return F(super.primaryFixedDim(), "2025", t);
  }
  onPrimaryFixed() {
    const t = h.fromPalette({ name: "on_primary_fixed", palette: (e) => e.primaryPalette, background: (e) => this.primaryFixedDim(), contrastCurve: (e) => w(7) });
    return F(super.onPrimaryFixed(), "2025", t);
  }
  onPrimaryFixedVariant() {
    const t = h.fromPalette({ name: "on_primary_fixed_variant", palette: (e) => e.primaryPalette, background: (e) => this.primaryFixedDim(), contrastCurve: (e) => w(4.5) });
    return F(super.onPrimaryFixedVariant(), "2025", t);
  }
  inversePrimary() {
    const t = h.fromPalette({ name: "inverse_primary", palette: (e) => e.primaryPalette, tone: (e) => R(e.primaryPalette), background: (e) => this.inverseSurface(), contrastCurve: (e) => e.platform === "phone" ? w(6) : w(7) });
    return F(super.inversePrimary(), "2025", t);
  }
  secondary() {
    const t = h.fromPalette({ name: "secondary", palette: (e) => e.secondaryPalette, tone: (e) => e.platform === "watch" ? e.variant === c.NEUTRAL ? 90 : R(e.secondaryPalette, 0, 90) : e.variant === c.NEUTRAL ? e.isDark ? st(e.secondaryPalette, 0, 98) : R(e.secondaryPalette) : e.variant === c.VIBRANT ? R(e.secondaryPalette, 0, e.isDark ? 90 : 98) : e.isDark ? 80 : R(e.secondaryPalette), isBackground: true, background: (e) => e.platform === "phone" ? this.highestSurface(e) : this.surfaceContainerHigh(), contrastCurve: (e) => e.platform === "phone" ? w(4.5) : w(7), toneDeltaPair: (e) => e.platform === "phone" ? new V(this.secondaryContainer(), this.secondary(), 5, "relative_lighter", true, "farther") : void 0 });
    return F(super.secondary(), "2025", t);
  }
  secondaryDim() {
    return h.fromPalette({ name: "secondary_dim", palette: (t) => t.secondaryPalette, tone: (t) => t.variant === c.NEUTRAL ? 85 : R(t.secondaryPalette, 0, 90), isBackground: true, background: (t) => this.surfaceContainerHigh(), contrastCurve: (t) => w(4.5), toneDeltaPair: (t) => new V(this.secondaryDim(), this.secondary(), 5, "darker", true, "farther") });
  }
  onSecondary() {
    const t = h.fromPalette({ name: "on_secondary", palette: (e) => e.secondaryPalette, background: (e) => e.platform === "phone" ? this.secondary() : this.secondaryDim(), contrastCurve: (e) => e.platform === "phone" ? w(6) : w(7) });
    return F(super.onSecondary(), "2025", t);
  }
  secondaryContainer() {
    const t = h.fromPalette({ name: "secondary_container", palette: (e) => e.secondaryPalette, tone: (e) => e.platform === "watch" ? 30 : e.variant === c.VIBRANT ? e.isDark ? st(e.secondaryPalette, 30, 40) : R(e.secondaryPalette, 84, 90) : e.variant === c.EXPRESSIVE ? e.isDark ? 15 : R(e.secondaryPalette, 90, 95) : e.isDark ? 25 : 90, isBackground: true, background: (e) => e.platform === "phone" ? this.highestSurface(e) : void 0, toneDeltaPair: (e) => e.platform === "watch" ? new V(this.secondaryContainer(), this.secondaryDim(), 10, "darker", true, "farther") : void 0, contrastCurve: (e) => e.platform === "phone" && e.contrastLevel > 0 ? w(1.5) : void 0 });
    return F(super.secondaryContainer(), "2025", t);
  }
  onSecondaryContainer() {
    const t = h.fromPalette({ name: "on_secondary_container", palette: (e) => e.secondaryPalette, background: (e) => this.secondaryContainer(), contrastCurve: (e) => e.platform === "phone" ? w(6) : w(7) });
    return F(super.onSecondaryContainer(), "2025", t);
  }
  secondaryFixed() {
    const t = h.fromPalette({ name: "secondary_fixed", palette: (e) => e.secondaryPalette, tone: (e) => {
      let r = Object.assign({}, e, { isDark: false, contrastLevel: 0 });
      return this.secondaryContainer().getTone(r);
    }, isBackground: true, background: (e) => e.platform === "phone" ? this.highestSurface(e) : void 0, contrastCurve: (e) => e.platform === "phone" && e.contrastLevel > 0 ? w(1.5) : void 0 });
    return F(super.secondaryFixed(), "2025", t);
  }
  secondaryFixedDim() {
    const t = h.fromPalette({ name: "secondary_fixed_dim", palette: (e) => e.secondaryPalette, tone: (e) => this.secondaryFixed().getTone(e), isBackground: true, toneDeltaPair: (e) => new V(this.secondaryFixedDim(), this.secondaryFixed(), 5, "darker", true, "exact") });
    return F(super.secondaryFixedDim(), "2025", t);
  }
  onSecondaryFixed() {
    const t = h.fromPalette({ name: "on_secondary_fixed", palette: (e) => e.secondaryPalette, background: (e) => this.secondaryFixedDim(), contrastCurve: (e) => w(7) });
    return F(super.onSecondaryFixed(), "2025", t);
  }
  onSecondaryFixedVariant() {
    const t = h.fromPalette({ name: "on_secondary_fixed_variant", palette: (e) => e.secondaryPalette, background: (e) => this.secondaryFixedDim(), contrastCurve: (e) => w(4.5) });
    return F(super.onSecondaryFixedVariant(), "2025", t);
  }
  tertiary() {
    const t = h.fromPalette({ name: "tertiary", palette: (e) => e.tertiaryPalette, tone: (e) => e.platform === "watch" ? e.variant === c.TONAL_SPOT ? R(e.tertiaryPalette, 0, 90) : R(e.tertiaryPalette) : e.variant === c.EXPRESSIVE || e.variant === c.VIBRANT ? R(e.tertiaryPalette, 0, x.isCyan(e.tertiaryPalette.hue) ? 88 : e.isDark ? 98 : 100) : e.isDark ? R(e.tertiaryPalette, 0, 98) : R(e.tertiaryPalette), isBackground: true, background: (e) => e.platform === "phone" ? this.highestSurface(e) : this.surfaceContainerHigh(), contrastCurve: (e) => e.platform === "phone" ? w(4.5) : w(7), toneDeltaPair: (e) => e.platform === "phone" ? new V(this.tertiaryContainer(), this.tertiary(), 5, "relative_lighter", true, "farther") : void 0 });
    return F(super.tertiary(), "2025", t);
  }
  tertiaryDim() {
    return h.fromPalette({ name: "tertiary_dim", palette: (t) => t.tertiaryPalette, tone: (t) => t.variant === c.TONAL_SPOT ? R(t.tertiaryPalette, 0, 90) : R(t.tertiaryPalette), isBackground: true, background: (t) => this.surfaceContainerHigh(), contrastCurve: (t) => w(4.5), toneDeltaPair: (t) => new V(this.tertiaryDim(), this.tertiary(), 5, "darker", true, "farther") });
  }
  onTertiary() {
    const t = h.fromPalette({ name: "on_tertiary", palette: (e) => e.tertiaryPalette, background: (e) => e.platform === "phone" ? this.tertiary() : this.tertiaryDim(), contrastCurve: (e) => e.platform === "phone" ? w(6) : w(7) });
    return F(super.onTertiary(), "2025", t);
  }
  tertiaryContainer() {
    const t = h.fromPalette({ name: "tertiary_container", palette: (e) => e.tertiaryPalette, tone: (e) => e.platform === "watch" ? e.variant === c.TONAL_SPOT ? R(e.tertiaryPalette, 0, 90) : R(e.tertiaryPalette) : e.variant === c.NEUTRAL ? e.isDark ? R(e.tertiaryPalette, 0, 93) : R(e.tertiaryPalette, 0, 96) : e.variant === c.TONAL_SPOT ? R(e.tertiaryPalette, 0, e.isDark ? 93 : 100) : e.variant === c.EXPRESSIVE ? R(e.tertiaryPalette, 75, x.isCyan(e.tertiaryPalette.hue) ? 88 : e.isDark ? 93 : 100) : e.isDark ? R(e.tertiaryPalette, 0, 93) : R(e.tertiaryPalette, 72, 100), isBackground: true, background: (e) => e.platform === "phone" ? this.highestSurface(e) : void 0, toneDeltaPair: (e) => e.platform === "watch" ? new V(this.tertiaryContainer(), this.tertiaryDim(), 10, "darker", true, "farther") : void 0, contrastCurve: (e) => e.platform === "phone" && e.contrastLevel > 0 ? w(1.5) : void 0 });
    return F(super.tertiaryContainer(), "2025", t);
  }
  onTertiaryContainer() {
    const t = h.fromPalette({ name: "on_tertiary_container", palette: (e) => e.tertiaryPalette, background: (e) => this.tertiaryContainer(), contrastCurve: (e) => e.platform === "phone" ? w(6) : w(7) });
    return F(super.onTertiaryContainer(), "2025", t);
  }
  tertiaryFixed() {
    const t = h.fromPalette({ name: "tertiary_fixed", palette: (e) => e.tertiaryPalette, tone: (e) => {
      let r = Object.assign({}, e, { isDark: false, contrastLevel: 0 });
      return this.tertiaryContainer().getTone(r);
    }, isBackground: true, background: (e) => e.platform === "phone" ? this.highestSurface(e) : void 0, contrastCurve: (e) => e.platform === "phone" && e.contrastLevel > 0 ? w(1.5) : void 0 });
    return F(super.tertiaryFixed(), "2025", t);
  }
  tertiaryFixedDim() {
    const t = h.fromPalette({ name: "tertiary_fixed_dim", palette: (e) => e.tertiaryPalette, tone: (e) => this.tertiaryFixed().getTone(e), isBackground: true, toneDeltaPair: (e) => new V(this.tertiaryFixedDim(), this.tertiaryFixed(), 5, "darker", true, "exact") });
    return F(super.tertiaryFixedDim(), "2025", t);
  }
  onTertiaryFixed() {
    const t = h.fromPalette({ name: "on_tertiary_fixed", palette: (e) => e.tertiaryPalette, background: (e) => this.tertiaryFixedDim(), contrastCurve: (e) => w(7) });
    return F(super.onTertiaryFixed(), "2025", t);
  }
  onTertiaryFixedVariant() {
    const t = h.fromPalette({ name: "on_tertiary_fixed_variant", palette: (e) => e.tertiaryPalette, background: (e) => this.tertiaryFixedDim(), contrastCurve: (e) => w(4.5) });
    return F(super.onTertiaryFixedVariant(), "2025", t);
  }
  error() {
    const t = h.fromPalette({ name: "error", palette: (e) => e.errorPalette, tone: (e) => e.platform === "phone" ? e.isDark ? st(e.errorPalette, 0, 98) : R(e.errorPalette) : st(e.errorPalette), isBackground: true, background: (e) => e.platform === "phone" ? this.highestSurface(e) : this.surfaceContainerHigh(), contrastCurve: (e) => e.platform === "phone" ? w(4.5) : w(7), toneDeltaPair: (e) => e.platform === "phone" ? new V(this.errorContainer(), this.error(), 5, "relative_lighter", true, "farther") : void 0 });
    return F(super.error(), "2025", t);
  }
  errorDim() {
    return h.fromPalette({ name: "error_dim", palette: (t) => t.errorPalette, tone: (t) => st(t.errorPalette), isBackground: true, background: (t) => this.surfaceContainerHigh(), contrastCurve: (t) => w(4.5), toneDeltaPair: (t) => new V(this.errorDim(), this.error(), 5, "darker", true, "farther") });
  }
  onError() {
    const t = h.fromPalette({ name: "on_error", palette: (e) => e.errorPalette, background: (e) => e.platform === "phone" ? this.error() : this.errorDim(), contrastCurve: (e) => e.platform === "phone" ? w(6) : w(7) });
    return F(super.onError(), "2025", t);
  }
  errorContainer() {
    const t = h.fromPalette({ name: "error_container", palette: (e) => e.errorPalette, tone: (e) => e.platform === "watch" ? 30 : e.isDark ? st(e.errorPalette, 30, 93) : R(e.errorPalette, 0, 90), isBackground: true, background: (e) => e.platform === "phone" ? this.highestSurface(e) : void 0, toneDeltaPair: (e) => e.platform === "watch" ? new V(this.errorContainer(), this.errorDim(), 10, "darker", true, "farther") : void 0, contrastCurve: (e) => e.platform === "phone" && e.contrastLevel > 0 ? w(1.5) : void 0 });
    return F(super.errorContainer(), "2025", t);
  }
  onErrorContainer() {
    const t = h.fromPalette({ name: "on_error_container", palette: (e) => e.errorPalette, background: (e) => this.errorContainer(), contrastCurve: (e) => e.platform === "phone" ? w(4.5) : w(7) });
    return F(super.onErrorContainer(), "2025", t);
  }
  surfaceVariant() {
    const t = Object.assign(this.surfaceContainerHighest().clone(), { name: "surface_variant" });
    return F(super.surfaceVariant(), "2025", t);
  }
  surfaceTint() {
    const t = Object.assign(this.primary().clone(), { name: "surface_tint" });
    return F(super.surfaceTint(), "2025", t);
  }
  background() {
    const t = Object.assign(this.surface().clone(), { name: "background" });
    return F(super.background(), "2025", t);
  }
  onBackground() {
    const t = Object.assign(this.onSurface().clone(), { name: "on_background", tone: (e) => e.platform === "watch" ? 100 : this.onSurface().getTone(e) });
    return F(super.onBackground(), "2025", t);
  }
}
class s {
  constructor() {
    this.allColors = [this.background(), this.onBackground(), this.surface(), this.surfaceDim(), this.surfaceBright(), this.surfaceContainerLowest(), this.surfaceContainerLow(), this.surfaceContainer(), this.surfaceContainerHigh(), this.surfaceContainerHighest(), this.onSurface(), this.onSurfaceVariant(), this.outline(), this.outlineVariant(), this.inverseSurface(), this.inverseOnSurface(), this.primary(), this.primaryDim(), this.onPrimary(), this.primaryContainer(), this.onPrimaryContainer(), this.primaryFixed(), this.primaryFixedDim(), this.onPrimaryFixed(), this.onPrimaryFixedVariant(), this.inversePrimary(), this.secondary(), this.secondaryDim(), this.onSecondary(), this.secondaryContainer(), this.onSecondaryContainer(), this.secondaryFixed(), this.secondaryFixedDim(), this.onSecondaryFixed(), this.onSecondaryFixedVariant(), this.tertiary(), this.tertiaryDim(), this.onTertiary(), this.tertiaryContainer(), this.onTertiaryContainer(), this.tertiaryFixed(), this.tertiaryFixedDim(), this.onTertiaryFixed(), this.onTertiaryFixedVariant(), this.error(), this.errorDim(), this.onError(), this.errorContainer(), this.onErrorContainer()].filter((t) => t !== void 0);
  }
  highestSurface(t) {
    return s.colorSpec.highestSurface(t);
  }
  primaryPaletteKeyColor() {
    return s.colorSpec.primaryPaletteKeyColor();
  }
  secondaryPaletteKeyColor() {
    return s.colorSpec.secondaryPaletteKeyColor();
  }
  tertiaryPaletteKeyColor() {
    return s.colorSpec.tertiaryPaletteKeyColor();
  }
  neutralPaletteKeyColor() {
    return s.colorSpec.neutralPaletteKeyColor();
  }
  neutralVariantPaletteKeyColor() {
    return s.colorSpec.neutralVariantPaletteKeyColor();
  }
  errorPaletteKeyColor() {
    return s.colorSpec.errorPaletteKeyColor();
  }
  background() {
    return s.colorSpec.background();
  }
  onBackground() {
    return s.colorSpec.onBackground();
  }
  surface() {
    return s.colorSpec.surface();
  }
  surfaceDim() {
    return s.colorSpec.surfaceDim();
  }
  surfaceBright() {
    return s.colorSpec.surfaceBright();
  }
  surfaceContainerLowest() {
    return s.colorSpec.surfaceContainerLowest();
  }
  surfaceContainerLow() {
    return s.colorSpec.surfaceContainerLow();
  }
  surfaceContainer() {
    return s.colorSpec.surfaceContainer();
  }
  surfaceContainerHigh() {
    return s.colorSpec.surfaceContainerHigh();
  }
  surfaceContainerHighest() {
    return s.colorSpec.surfaceContainerHighest();
  }
  onSurface() {
    return s.colorSpec.onSurface();
  }
  surfaceVariant() {
    return s.colorSpec.surfaceVariant();
  }
  onSurfaceVariant() {
    return s.colorSpec.onSurfaceVariant();
  }
  outline() {
    return s.colorSpec.outline();
  }
  outlineVariant() {
    return s.colorSpec.outlineVariant();
  }
  inverseSurface() {
    return s.colorSpec.inverseSurface();
  }
  inverseOnSurface() {
    return s.colorSpec.inverseOnSurface();
  }
  shadow() {
    return s.colorSpec.shadow();
  }
  scrim() {
    return s.colorSpec.scrim();
  }
  surfaceTint() {
    return s.colorSpec.surfaceTint();
  }
  primary() {
    return s.colorSpec.primary();
  }
  primaryDim() {
    return s.colorSpec.primaryDim();
  }
  onPrimary() {
    return s.colorSpec.onPrimary();
  }
  primaryContainer() {
    return s.colorSpec.primaryContainer();
  }
  onPrimaryContainer() {
    return s.colorSpec.onPrimaryContainer();
  }
  inversePrimary() {
    return s.colorSpec.inversePrimary();
  }
  primaryFixed() {
    return s.colorSpec.primaryFixed();
  }
  primaryFixedDim() {
    return s.colorSpec.primaryFixedDim();
  }
  onPrimaryFixed() {
    return s.colorSpec.onPrimaryFixed();
  }
  onPrimaryFixedVariant() {
    return s.colorSpec.onPrimaryFixedVariant();
  }
  secondary() {
    return s.colorSpec.secondary();
  }
  secondaryDim() {
    return s.colorSpec.secondaryDim();
  }
  onSecondary() {
    return s.colorSpec.onSecondary();
  }
  secondaryContainer() {
    return s.colorSpec.secondaryContainer();
  }
  onSecondaryContainer() {
    return s.colorSpec.onSecondaryContainer();
  }
  secondaryFixed() {
    return s.colorSpec.secondaryFixed();
  }
  secondaryFixedDim() {
    return s.colorSpec.secondaryFixedDim();
  }
  onSecondaryFixed() {
    return s.colorSpec.onSecondaryFixed();
  }
  onSecondaryFixedVariant() {
    return s.colorSpec.onSecondaryFixedVariant();
  }
  tertiary() {
    return s.colorSpec.tertiary();
  }
  tertiaryDim() {
    return s.colorSpec.tertiaryDim();
  }
  onTertiary() {
    return s.colorSpec.onTertiary();
  }
  tertiaryContainer() {
    return s.colorSpec.tertiaryContainer();
  }
  onTertiaryContainer() {
    return s.colorSpec.onTertiaryContainer();
  }
  tertiaryFixed() {
    return s.colorSpec.tertiaryFixed();
  }
  tertiaryFixedDim() {
    return s.colorSpec.tertiaryFixedDim();
  }
  onTertiaryFixed() {
    return s.colorSpec.onTertiaryFixed();
  }
  onTertiaryFixedVariant() {
    return s.colorSpec.onTertiaryFixedVariant();
  }
  error() {
    return s.colorSpec.error();
  }
  errorDim() {
    return s.colorSpec.errorDim();
  }
  onError() {
    return s.colorSpec.onError();
  }
  errorContainer() {
    return s.colorSpec.errorContainer();
  }
  onErrorContainer() {
    return s.colorSpec.onErrorContainer();
  }
  static highestSurface(t) {
    return s.colorSpec.highestSurface(t);
  }
}
s.contentAccentToneDelta = 15, s.colorSpec = new xe(), s.primaryPaletteKeyColor = s.colorSpec.primaryPaletteKeyColor(), s.secondaryPaletteKeyColor = s.colorSpec.secondaryPaletteKeyColor(), s.tertiaryPaletteKeyColor = s.colorSpec.tertiaryPaletteKeyColor(), s.neutralPaletteKeyColor = s.colorSpec.neutralPaletteKeyColor(), s.neutralVariantPaletteKeyColor = s.colorSpec.neutralVariantPaletteKeyColor(), s.background = s.colorSpec.background(), s.onBackground = s.colorSpec.onBackground(), s.surface = s.colorSpec.surface(), s.surfaceDim = s.colorSpec.surfaceDim(), s.surfaceBright = s.colorSpec.surfaceBright(), s.surfaceContainerLowest = s.colorSpec.surfaceContainerLowest(), s.surfaceContainerLow = s.colorSpec.surfaceContainerLow(), s.surfaceContainer = s.colorSpec.surfaceContainer(), s.surfaceContainerHigh = s.colorSpec.surfaceContainerHigh(), s.surfaceContainerHighest = s.colorSpec.surfaceContainerHighest(), s.onSurface = s.colorSpec.onSurface(), s.surfaceVariant = s.colorSpec.surfaceVariant(), s.onSurfaceVariant = s.colorSpec.onSurfaceVariant(), s.inverseSurface = s.colorSpec.inverseSurface(), s.inverseOnSurface = s.colorSpec.inverseOnSurface(), s.outline = s.colorSpec.outline(), s.outlineVariant = s.colorSpec.outlineVariant(), s.shadow = s.colorSpec.shadow(), s.scrim = s.colorSpec.scrim(), s.surfaceTint = s.colorSpec.surfaceTint(), s.primary = s.colorSpec.primary(), s.onPrimary = s.colorSpec.onPrimary(), s.primaryContainer = s.colorSpec.primaryContainer(), s.onPrimaryContainer = s.colorSpec.onPrimaryContainer(), s.inversePrimary = s.colorSpec.inversePrimary(), s.secondary = s.colorSpec.secondary(), s.onSecondary = s.colorSpec.onSecondary(), s.secondaryContainer = s.colorSpec.secondaryContainer(), s.onSecondaryContainer = s.colorSpec.onSecondaryContainer(), s.tertiary = s.colorSpec.tertiary(), s.onTertiary = s.colorSpec.onTertiary(), s.tertiaryContainer = s.colorSpec.tertiaryContainer(), s.onTertiaryContainer = s.colorSpec.onTertiaryContainer(), s.error = s.colorSpec.error(), s.onError = s.colorSpec.onError(), s.errorContainer = s.colorSpec.errorContainer(), s.onErrorContainer = s.colorSpec.onErrorContainer(), s.primaryFixed = s.colorSpec.primaryFixed(), s.primaryFixedDim = s.colorSpec.primaryFixedDim(), s.onPrimaryFixed = s.colorSpec.onPrimaryFixed(), s.onPrimaryFixedVariant = s.colorSpec.onPrimaryFixedVariant(), s.secondaryFixed = s.colorSpec.secondaryFixed(), s.secondaryFixedDim = s.colorSpec.secondaryFixedDim(), s.onSecondaryFixed = s.colorSpec.onSecondaryFixed(), s.onSecondaryFixedVariant = s.colorSpec.onSecondaryFixedVariant(), s.tertiaryFixed = s.colorSpec.tertiaryFixed(), s.tertiaryFixedDim = s.colorSpec.tertiaryFixedDim(), s.onTertiaryFixed = s.colorSpec.onTertiaryFixed(), s.onTertiaryFixedVariant = s.colorSpec.onTertiaryFixedVariant();
class v {
  static maybeFallbackSpecVersion(t, e) {
    switch (e) {
      case c.EXPRESSIVE:
      case c.VIBRANT:
      case c.TONAL_SPOT:
      case c.NEUTRAL:
        return t;
      default:
        return "2021";
    }
  }
  constructor(t) {
    var _a, _b, _c, _d, _e2, _f, _g, _h, _i;
    this.sourceColorArgb = t.sourceColorHct.toInt(), this.variant = t.variant, this.contrastLevel = t.contrastLevel, this.isDark = t.isDark, this.platform = (_a = t.platform) != null ? _a : "phone", this.specVersion = v.maybeFallbackSpecVersion((_b = t.specVersion) != null ? _b : "2021", this.variant), this.sourceColorHct = t.sourceColorHct, this.primaryPalette = (_c = t.primaryPalette) != null ? _c : dt(this.specVersion).getPrimaryPalette(this.variant, t.sourceColorHct, this.isDark, this.platform, this.contrastLevel), this.secondaryPalette = (_d = t.secondaryPalette) != null ? _d : dt(this.specVersion).getSecondaryPalette(this.variant, t.sourceColorHct, this.isDark, this.platform, this.contrastLevel), this.tertiaryPalette = (_e2 = t.tertiaryPalette) != null ? _e2 : dt(this.specVersion).getTertiaryPalette(this.variant, t.sourceColorHct, this.isDark, this.platform, this.contrastLevel), this.neutralPalette = (_f = t.neutralPalette) != null ? _f : dt(this.specVersion).getNeutralPalette(this.variant, t.sourceColorHct, this.isDark, this.platform, this.contrastLevel), this.neutralVariantPalette = (_g = t.neutralVariantPalette) != null ? _g : dt(this.specVersion).getNeutralVariantPalette(this.variant, t.sourceColorHct, this.isDark, this.platform, this.contrastLevel), this.errorPalette = (_i = (_h = t.errorPalette) != null ? _h : dt(this.specVersion).getErrorPalette(this.variant, t.sourceColorHct, this.isDark, this.platform, this.contrastLevel)) != null ? _i : A.fromHueAndChroma(25, 84), this.colors = new s();
  }
  toString() {
    return `Scheme: variant=${c[this.variant]}, mode=${this.isDark ? "dark" : "light"}, platform=${this.platform}, contrastLevel=${this.contrastLevel.toFixed(1)}, seed=${this.sourceColorHct.toString()}, specVersion=${this.specVersion}`;
  }
  static getPiecewiseHue(t, e, r) {
    const n = Math.min(e.length - 1, r.length), a = t.hue;
    for (let i = 0; i < n; i++) if (a >= e[i] && a < e[i + 1]) return K(r[i]);
    return a;
  }
  static getRotatedHue(t, e, r) {
    let n = v.getPiecewiseHue(t, e, r);
    return Math.min(e.length - 1, r.length) <= 0 && (n = 0), K(t.hue + n);
  }
  getArgb(t) {
    return t.getArgb(this);
  }
  getHct(t) {
    return t.getHct(this);
  }
  get primaryPaletteKeyColor() {
    return this.getArgb(this.colors.primaryPaletteKeyColor());
  }
  get secondaryPaletteKeyColor() {
    return this.getArgb(this.colors.secondaryPaletteKeyColor());
  }
  get tertiaryPaletteKeyColor() {
    return this.getArgb(this.colors.tertiaryPaletteKeyColor());
  }
  get neutralPaletteKeyColor() {
    return this.getArgb(this.colors.neutralPaletteKeyColor());
  }
  get neutralVariantPaletteKeyColor() {
    return this.getArgb(this.colors.neutralVariantPaletteKeyColor());
  }
  get errorPaletteKeyColor() {
    return this.getArgb(this.colors.errorPaletteKeyColor());
  }
  get background() {
    return this.getArgb(this.colors.background());
  }
  get onBackground() {
    return this.getArgb(this.colors.onBackground());
  }
  get surface() {
    return this.getArgb(this.colors.surface());
  }
  get surfaceDim() {
    return this.getArgb(this.colors.surfaceDim());
  }
  get surfaceBright() {
    return this.getArgb(this.colors.surfaceBright());
  }
  get surfaceContainerLowest() {
    return this.getArgb(this.colors.surfaceContainerLowest());
  }
  get surfaceContainerLow() {
    return this.getArgb(this.colors.surfaceContainerLow());
  }
  get surfaceContainer() {
    return this.getArgb(this.colors.surfaceContainer());
  }
  get surfaceContainerHigh() {
    return this.getArgb(this.colors.surfaceContainerHigh());
  }
  get surfaceContainerHighest() {
    return this.getArgb(this.colors.surfaceContainerHighest());
  }
  get onSurface() {
    return this.getArgb(this.colors.onSurface());
  }
  get surfaceVariant() {
    return this.getArgb(this.colors.surfaceVariant());
  }
  get onSurfaceVariant() {
    return this.getArgb(this.colors.onSurfaceVariant());
  }
  get inverseSurface() {
    return this.getArgb(this.colors.inverseSurface());
  }
  get inverseOnSurface() {
    return this.getArgb(this.colors.inverseOnSurface());
  }
  get outline() {
    return this.getArgb(this.colors.outline());
  }
  get outlineVariant() {
    return this.getArgb(this.colors.outlineVariant());
  }
  get shadow() {
    return this.getArgb(this.colors.shadow());
  }
  get scrim() {
    return this.getArgb(this.colors.scrim());
  }
  get surfaceTint() {
    return this.getArgb(this.colors.surfaceTint());
  }
  get primary() {
    return this.getArgb(this.colors.primary());
  }
  get primaryDim() {
    const t = this.colors.primaryDim();
    if (t === void 0) throw new Error("`primaryDim` color is undefined prior to 2025 spec.");
    return this.getArgb(t);
  }
  get onPrimary() {
    return this.getArgb(this.colors.onPrimary());
  }
  get primaryContainer() {
    return this.getArgb(this.colors.primaryContainer());
  }
  get onPrimaryContainer() {
    return this.getArgb(this.colors.onPrimaryContainer());
  }
  get primaryFixed() {
    return this.getArgb(this.colors.primaryFixed());
  }
  get primaryFixedDim() {
    return this.getArgb(this.colors.primaryFixedDim());
  }
  get onPrimaryFixed() {
    return this.getArgb(this.colors.onPrimaryFixed());
  }
  get onPrimaryFixedVariant() {
    return this.getArgb(this.colors.onPrimaryFixedVariant());
  }
  get inversePrimary() {
    return this.getArgb(this.colors.inversePrimary());
  }
  get secondary() {
    return this.getArgb(this.colors.secondary());
  }
  get secondaryDim() {
    const t = this.colors.secondaryDim();
    if (t === void 0) throw new Error("`secondaryDim` color is undefined prior to 2025 spec.");
    return this.getArgb(t);
  }
  get onSecondary() {
    return this.getArgb(this.colors.onSecondary());
  }
  get secondaryContainer() {
    return this.getArgb(this.colors.secondaryContainer());
  }
  get onSecondaryContainer() {
    return this.getArgb(this.colors.onSecondaryContainer());
  }
  get secondaryFixed() {
    return this.getArgb(this.colors.secondaryFixed());
  }
  get secondaryFixedDim() {
    return this.getArgb(this.colors.secondaryFixedDim());
  }
  get onSecondaryFixed() {
    return this.getArgb(this.colors.onSecondaryFixed());
  }
  get onSecondaryFixedVariant() {
    return this.getArgb(this.colors.onSecondaryFixedVariant());
  }
  get tertiary() {
    return this.getArgb(this.colors.tertiary());
  }
  get tertiaryDim() {
    const t = this.colors.tertiaryDim();
    if (t === void 0) throw new Error("`tertiaryDim` color is undefined prior to 2025 spec.");
    return this.getArgb(t);
  }
  get onTertiary() {
    return this.getArgb(this.colors.onTertiary());
  }
  get tertiaryContainer() {
    return this.getArgb(this.colors.tertiaryContainer());
  }
  get onTertiaryContainer() {
    return this.getArgb(this.colors.onTertiaryContainer());
  }
  get tertiaryFixed() {
    return this.getArgb(this.colors.tertiaryFixed());
  }
  get tertiaryFixedDim() {
    return this.getArgb(this.colors.tertiaryFixedDim());
  }
  get onTertiaryFixed() {
    return this.getArgb(this.colors.onTertiaryFixed());
  }
  get onTertiaryFixedVariant() {
    return this.getArgb(this.colors.onTertiaryFixedVariant());
  }
  get error() {
    return this.getArgb(this.colors.error());
  }
  get errorDim() {
    const t = this.colors.errorDim();
    if (t === void 0) throw new Error("`errorDim` color is undefined prior to 2025 spec.");
    return this.getArgb(t);
  }
  get onError() {
    return this.getArgb(this.colors.onError());
  }
  get errorContainer() {
    return this.getArgb(this.colors.errorContainer());
  }
  get onErrorContainer() {
    return this.getArgb(this.colors.onErrorContainer());
  }
}
v.DEFAULT_SPEC_VERSION = "2021", v.DEFAULT_PLATFORM = "phone";
class ee {
  getPrimaryPalette(t, e, r, n, a) {
    switch (t) {
      case c.CONTENT:
      case c.FIDELITY:
        return A.fromHueAndChroma(e.hue, e.chroma);
      case c.FRUIT_SALAD:
        return A.fromHueAndChroma(K(e.hue - 50), 48);
      case c.MONOCHROME:
        return A.fromHueAndChroma(e.hue, 0);
      case c.NEUTRAL:
        return A.fromHueAndChroma(e.hue, 12);
      case c.RAINBOW:
        return A.fromHueAndChroma(e.hue, 48);
      case c.TONAL_SPOT:
        return A.fromHueAndChroma(e.hue, 36);
      case c.EXPRESSIVE:
        return A.fromHueAndChroma(K(e.hue + 240), 40);
      case c.VIBRANT:
        return A.fromHueAndChroma(e.hue, 200);
      default:
        throw new Error(`Unsupported variant: ${t}`);
    }
  }
  getSecondaryPalette(t, e, r, n, a) {
    switch (t) {
      case c.CONTENT:
      case c.FIDELITY:
        return A.fromHueAndChroma(e.hue, Math.max(e.chroma - 32, e.chroma * 0.5));
      case c.FRUIT_SALAD:
        return A.fromHueAndChroma(K(e.hue - 50), 36);
      case c.MONOCHROME:
        return A.fromHueAndChroma(e.hue, 0);
      case c.NEUTRAL:
        return A.fromHueAndChroma(e.hue, 8);
      case c.RAINBOW:
        return A.fromHueAndChroma(e.hue, 16);
      case c.TONAL_SPOT:
        return A.fromHueAndChroma(e.hue, 16);
      case c.EXPRESSIVE:
        return A.fromHueAndChroma(v.getRotatedHue(e, [0, 21, 51, 121, 151, 191, 271, 321, 360], [45, 95, 45, 20, 45, 90, 45, 45, 45]), 24);
      case c.VIBRANT:
        return A.fromHueAndChroma(v.getRotatedHue(e, [0, 41, 61, 101, 131, 181, 251, 301, 360], [18, 15, 10, 12, 15, 18, 15, 12, 12]), 24);
      default:
        throw new Error(`Unsupported variant: ${t}`);
    }
  }
  getTertiaryPalette(t, e, r, n, a) {
    switch (t) {
      case c.CONTENT:
        return A.fromHct(mt.fixIfDisliked(new ht(e).analogous(3, 6)[2]));
      case c.FIDELITY:
        return A.fromHct(mt.fixIfDisliked(new ht(e).complement));
      case c.FRUIT_SALAD:
        return A.fromHueAndChroma(e.hue, 36);
      case c.MONOCHROME:
        return A.fromHueAndChroma(e.hue, 0);
      case c.NEUTRAL:
        return A.fromHueAndChroma(e.hue, 16);
      case c.RAINBOW:
      case c.TONAL_SPOT:
        return A.fromHueAndChroma(K(e.hue + 60), 24);
      case c.EXPRESSIVE:
        return A.fromHueAndChroma(v.getRotatedHue(e, [0, 21, 51, 121, 151, 191, 271, 321, 360], [120, 120, 20, 45, 20, 15, 20, 120, 120]), 32);
      case c.VIBRANT:
        return A.fromHueAndChroma(v.getRotatedHue(e, [0, 41, 61, 101, 131, 181, 251, 301, 360], [35, 30, 20, 25, 30, 35, 30, 25, 25]), 32);
      default:
        throw new Error(`Unsupported variant: ${t}`);
    }
  }
  getNeutralPalette(t, e, r, n, a) {
    switch (t) {
      case c.CONTENT:
      case c.FIDELITY:
        return A.fromHueAndChroma(e.hue, e.chroma / 8);
      case c.FRUIT_SALAD:
        return A.fromHueAndChroma(e.hue, 10);
      case c.MONOCHROME:
        return A.fromHueAndChroma(e.hue, 0);
      case c.NEUTRAL:
        return A.fromHueAndChroma(e.hue, 2);
      case c.RAINBOW:
        return A.fromHueAndChroma(e.hue, 0);
      case c.TONAL_SPOT:
        return A.fromHueAndChroma(e.hue, 6);
      case c.EXPRESSIVE:
        return A.fromHueAndChroma(K(e.hue + 15), 8);
      case c.VIBRANT:
        return A.fromHueAndChroma(e.hue, 10);
      default:
        throw new Error(`Unsupported variant: ${t}`);
    }
  }
  getNeutralVariantPalette(t, e, r, n, a) {
    switch (t) {
      case c.CONTENT:
        return A.fromHueAndChroma(e.hue, e.chroma / 8 + 4);
      case c.FIDELITY:
        return A.fromHueAndChroma(e.hue, e.chroma / 8 + 4);
      case c.FRUIT_SALAD:
        return A.fromHueAndChroma(e.hue, 16);
      case c.MONOCHROME:
        return A.fromHueAndChroma(e.hue, 0);
      case c.NEUTRAL:
        return A.fromHueAndChroma(e.hue, 2);
      case c.RAINBOW:
        return A.fromHueAndChroma(e.hue, 0);
      case c.TONAL_SPOT:
        return A.fromHueAndChroma(e.hue, 8);
      case c.EXPRESSIVE:
        return A.fromHueAndChroma(K(e.hue + 15), 12);
      case c.VIBRANT:
        return A.fromHueAndChroma(e.hue, 12);
      default:
        throw new Error(`Unsupported variant: ${t}`);
    }
  }
  getErrorPalette(t, e, r, n, a) {
  }
}
class J extends ee {
  getPrimaryPalette(t, e, r, n, a) {
    switch (t) {
      case c.NEUTRAL:
        return A.fromHueAndChroma(e.hue, n === "phone" ? x.isBlue(e.hue) ? 12 : 8 : x.isBlue(e.hue) ? 16 : 12);
      case c.TONAL_SPOT:
        return A.fromHueAndChroma(e.hue, n === "phone" && r ? 26 : 32);
      case c.EXPRESSIVE:
        return A.fromHueAndChroma(e.hue, n === "phone" ? r ? 36 : 48 : 40);
      case c.VIBRANT:
        return A.fromHueAndChroma(e.hue, n === "phone" ? 74 : 56);
      default:
        return super.getPrimaryPalette(t, e, r, n, a);
    }
  }
  getSecondaryPalette(t, e, r, n, a) {
    switch (t) {
      case c.NEUTRAL:
        return A.fromHueAndChroma(e.hue, n === "phone" ? x.isBlue(e.hue) ? 6 : 4 : x.isBlue(e.hue) ? 10 : 6);
      case c.TONAL_SPOT:
        return A.fromHueAndChroma(e.hue, 16);
      case c.EXPRESSIVE:
        return A.fromHueAndChroma(v.getRotatedHue(e, [0, 105, 140, 204, 253, 278, 300, 333, 360], [-160, 155, -100, 96, -96, -156, -165, -160]), n === "phone" && r ? 16 : 24);
      case c.VIBRANT:
        return A.fromHueAndChroma(v.getRotatedHue(e, [0, 38, 105, 140, 333, 360], [-14, 10, -14, 10, -14]), n === "phone" ? 56 : 36);
      default:
        return super.getSecondaryPalette(t, e, r, n, a);
    }
  }
  getTertiaryPalette(t, e, r, n, a) {
    switch (t) {
      case c.NEUTRAL:
        return A.fromHueAndChroma(v.getRotatedHue(e, [0, 38, 105, 161, 204, 278, 333, 360], [-32, 26, 10, -39, 24, -15, -32]), n === "phone" ? 20 : 36);
      case c.TONAL_SPOT:
        return A.fromHueAndChroma(v.getRotatedHue(e, [0, 20, 71, 161, 333, 360], [-40, 48, -32, 40, -32]), n === "phone" ? 28 : 32);
      case c.EXPRESSIVE:
        return A.fromHueAndChroma(v.getRotatedHue(e, [0, 105, 140, 204, 253, 278, 300, 333, 360], [-165, 160, -105, 101, -101, -160, -170, -165]), 48);
      case c.VIBRANT:
        return A.fromHueAndChroma(v.getRotatedHue(e, [0, 38, 71, 105, 140, 161, 253, 333, 360], [-72, 35, 24, -24, 62, 50, 62, -72]), 56);
      default:
        return super.getTertiaryPalette(t, e, r, n, a);
    }
  }
  static getExpressiveNeutralHue(t) {
    return v.getRotatedHue(t, [0, 71, 124, 253, 278, 300, 360], [10, 0, 10, 0, 10, 0]);
  }
  static getExpressiveNeutralChroma(t, e, r) {
    const n = J.getExpressiveNeutralHue(t);
    return r === "phone" ? e ? x.isYellow(n) ? 6 : 14 : 18 : 12;
  }
  static getVibrantNeutralHue(t) {
    return v.getRotatedHue(t, [0, 38, 105, 140, 333, 360], [-14, 10, -14, 10, -14]);
  }
  static getVibrantNeutralChroma(t, e) {
    const r = J.getVibrantNeutralHue(t);
    return e === "phone" || x.isBlue(r) ? 28 : 20;
  }
  getNeutralPalette(t, e, r, n, a) {
    switch (t) {
      case c.NEUTRAL:
        return A.fromHueAndChroma(e.hue, n === "phone" ? 1.4 : 6);
      case c.TONAL_SPOT:
        return A.fromHueAndChroma(e.hue, n === "phone" ? 5 : 10);
      case c.EXPRESSIVE:
        return A.fromHueAndChroma(J.getExpressiveNeutralHue(e), J.getExpressiveNeutralChroma(e, r, n));
      case c.VIBRANT:
        return A.fromHueAndChroma(J.getVibrantNeutralHue(e), J.getVibrantNeutralChroma(e, n));
      default:
        return super.getNeutralPalette(t, e, r, n, a);
    }
  }
  getNeutralVariantPalette(t, e, r, n, a) {
    switch (t) {
      case c.NEUTRAL:
        return A.fromHueAndChroma(e.hue, (n === "phone" ? 1.4 : 6) * 2.2);
      case c.TONAL_SPOT:
        return A.fromHueAndChroma(e.hue, (n === "phone" ? 5 : 10) * 1.7);
      case c.EXPRESSIVE:
        const i = J.getExpressiveNeutralHue(e), u = J.getExpressiveNeutralChroma(e, r, n);
        return A.fromHueAndChroma(i, u * (i >= 105 && i < 125 ? 1.6 : 2.3));
      case c.VIBRANT:
        const f = J.getVibrantNeutralHue(e), p = J.getVibrantNeutralChroma(e, n);
        return A.fromHueAndChroma(f, p * 1.29);
      default:
        return super.getNeutralVariantPalette(t, e, r, n, a);
    }
  }
  getErrorPalette(t, e, r, n, a) {
    const i = v.getPiecewiseHue(e, [0, 3, 13, 23, 33, 43, 153, 273, 360], [12, 22, 32, 12, 22, 32, 22, 12]);
    switch (t) {
      case c.NEUTRAL:
        return A.fromHueAndChroma(i, n === "phone" ? 50 : 40);
      case c.TONAL_SPOT:
        return A.fromHueAndChroma(i, n === "phone" ? 60 : 48);
      case c.EXPRESSIVE:
        return A.fromHueAndChroma(i, n === "phone" ? 64 : 48);
      case c.VIBRANT:
        return A.fromHueAndChroma(i, n === "phone" ? 80 : 60);
      default:
        return super.getErrorPalette(t, e, r, n, a);
    }
  }
}
const be = new ee(), we = new J();
function dt(o) {
  return o === "2025" ? we : be;
}
class U {
  static of(t) {
    return new U(t, false);
  }
  static contentOf(t) {
    return new U(t, true);
  }
  static fromColors(t) {
    return U.createPaletteFromColors(false, t);
  }
  static contentFromColors(t) {
    return U.createPaletteFromColors(true, t);
  }
  static createPaletteFromColors(t, e) {
    const r = new U(e.primary, t);
    if (e.secondary) {
      const n = new U(e.secondary, t);
      r.a2 = n.a1;
    }
    if (e.tertiary) {
      const n = new U(e.tertiary, t);
      r.a3 = n.a1;
    }
    if (e.error) {
      const n = new U(e.error, t);
      r.error = n.a1;
    }
    if (e.neutral) {
      const n = new U(e.neutral, t);
      r.n1 = n.n1;
    }
    if (e.neutralVariant) {
      const n = new U(e.neutralVariant, t);
      r.n2 = n.n2;
    }
    return r;
  }
  constructor(t, e) {
    const r = x.fromInt(t), n = r.hue, a = r.chroma;
    e ? (this.a1 = A.fromHueAndChroma(n, a), this.a2 = A.fromHueAndChroma(n, a / 3), this.a3 = A.fromHueAndChroma(n + 60, a / 2), this.n1 = A.fromHueAndChroma(n, Math.min(a / 12, 4)), this.n2 = A.fromHueAndChroma(n, Math.min(a / 6, 8))) : (this.a1 = A.fromHueAndChroma(n, Math.max(48, a)), this.a2 = A.fromHueAndChroma(n, 16), this.a3 = A.fromHueAndChroma(n + 60, 24), this.n1 = A.fromHueAndChroma(n, 4), this.n2 = A.fromHueAndChroma(n, 8)), this.error = A.fromHueAndChroma(25, 84);
  }
}
class Ee {
  fromInt(t) {
    return _t(t);
  }
  toInt(t) {
    return Wt(t[0], t[1], t[2]);
  }
  distance(t, e) {
    const r = t[0] - e[0], n = t[1] - e[1], a = t[2] - e[2];
    return r * r + n * n + a * a;
  }
}
const Fe = 10, De = 3;
class re {
  static quantize(t, e, r) {
    const n = /* @__PURE__ */ new Map(), a = new Array(), i = new Array(), u = new Ee();
    let f = 0;
    for (let T = 0; T < t.length; T++) {
      const b = t[T], B = n.get(b);
      B === void 0 ? (f++, a.push(u.fromInt(b)), i.push(b), n.set(b, 1)) : n.set(b, B + 1);
    }
    const p = new Array();
    for (let T = 0; T < f; T++) {
      const b = i[T], B = n.get(b);
      B !== void 0 && (p[T] = B);
    }
    let l = Math.min(r, f);
    e.length > 0 && (l = Math.min(l, e.length));
    const y = new Array();
    for (let T = 0; T < e.length; T++) y.push(u.fromInt(e[T]));
    const P = l - y.length;
    if (e.length === 0 && P > 0) for (let T = 0; T < P; T++) {
      const b = Math.random() * 100, B = Math.random() * 201 + -100, L = Math.random() * 201 + -100;
      y.push(new Array(b, B, L));
    }
    const g = new Array();
    for (let T = 0; T < f; T++) g.push(Math.floor(Math.random() * l));
    const m = new Array();
    for (let T = 0; T < l; T++) {
      m.push(new Array());
      for (let b = 0; b < l; b++) m[T].push(0);
    }
    const d = new Array();
    for (let T = 0; T < l; T++) {
      d.push(new Array());
      for (let b = 0; b < l; b++) d[T].push(new Ie());
    }
    const C = new Array();
    for (let T = 0; T < l; T++) C.push(0);
    for (let T = 0; T < Fe; T++) {
      for (let S = 0; S < l; S++) {
        for (let I = S + 1; I < l; I++) {
          const N = u.distance(y[S], y[I]);
          d[I][S].distance = N, d[I][S].index = S, d[S][I].distance = N, d[S][I].index = I;
        }
        d[S].sort();
        for (let I = 0; I < l; I++) m[S][I] = d[S][I].index;
      }
      let b = 0;
      for (let S = 0; S < f; S++) {
        const I = a[S], N = g[S], O = y[N], X = u.distance(I, O);
        let W = X, tt = -1;
        for (let G = 0; G < l; G++) {
          if (d[N][G].distance >= 4 * X) continue;
          const ut = u.distance(I, y[G]);
          ut < W && (W = ut, tt = G);
        }
        tt !== -1 && Math.abs(Math.sqrt(W) - Math.sqrt(X)) > De && (b++, g[S] = tt);
      }
      if (b === 0 && T !== 0) break;
      const B = new Array(l).fill(0), L = new Array(l).fill(0), M = new Array(l).fill(0);
      for (let S = 0; S < l; S++) C[S] = 0;
      for (let S = 0; S < f; S++) {
        const I = g[S], N = a[S], O = p[S];
        C[I] += O, B[I] += N[0] * O, L[I] += N[1] * O, M[I] += N[2] * O;
      }
      for (let S = 0; S < l; S++) {
        const I = C[S];
        if (I === 0) {
          y[S] = [0, 0, 0];
          continue;
        }
        const N = B[S] / I, O = L[S] / I, X = M[S] / I;
        y[S] = [N, O, X];
      }
    }
    const D = /* @__PURE__ */ new Map();
    for (let T = 0; T < l; T++) {
      const b = C[T];
      if (b === 0) continue;
      const B = u.toInt(y[T]);
      D.has(B) || D.set(B, b);
    }
    return D;
  }
}
class Ie {
  constructor() {
    this.distance = -1, this.index = -1;
  }
}
class ne {
  static quantize(t) {
    var _a;
    const e = /* @__PURE__ */ new Map();
    for (let r = 0; r < t.length; r++) {
      const n = t[r];
      Vt(n) < 255 || e.set(n, ((_a = e.get(n)) != null ? _a : 0) + 1);
    }
    return e;
  }
}
const Dt = 5, Q = 33, Tt = 35937, j = { RED: "red", GREEN: "green", BLUE: "blue" };
class ae {
  constructor(t = [], e = [], r = [], n = [], a = [], i = []) {
    this.weights = t, this.momentsR = e, this.momentsG = r, this.momentsB = n, this.moments = a, this.cubes = i;
  }
  quantize(t, e) {
    this.constructHistogram(t), this.computeMoments();
    const r = this.createBoxes(e);
    return this.createResult(r.resultCount);
  }
  constructHistogram(t) {
    var _a;
    this.weights = Array.from({ length: Tt }).fill(0), this.momentsR = Array.from({ length: Tt }).fill(0), this.momentsG = Array.from({ length: Tt }).fill(0), this.momentsB = Array.from({ length: Tt }).fill(0), this.moments = Array.from({ length: Tt }).fill(0);
    const e = ne.quantize(t);
    for (const [r, n] of e.entries()) {
      const a = yt(r), i = Pt(r), u = Ct(r), f = 8 - Dt, p = (a >> f) + 1, l = (i >> f) + 1, y = (u >> f) + 1, P = this.getIndex(p, l, y);
      this.weights[P] = ((_a = this.weights[P]) != null ? _a : 0) + n, this.momentsR[P] += n * a, this.momentsG[P] += n * i, this.momentsB[P] += n * u, this.moments[P] += n * (a * a + i * i + u * u);
    }
  }
  computeMoments() {
    for (let t = 1; t < Q; t++) {
      const e = Array.from({ length: Q }).fill(0), r = Array.from({ length: Q }).fill(0), n = Array.from({ length: Q }).fill(0), a = Array.from({ length: Q }).fill(0), i = Array.from({ length: Q }).fill(0);
      for (let u = 1; u < Q; u++) {
        let f = 0, p = 0, l = 0, y = 0, P = 0;
        for (let g = 1; g < Q; g++) {
          const m = this.getIndex(t, u, g);
          f += this.weights[m], p += this.momentsR[m], l += this.momentsG[m], y += this.momentsB[m], P += this.moments[m], e[g] += f, r[g] += p, n[g] += l, a[g] += y, i[g] += P;
          const d = this.getIndex(t - 1, u, g);
          this.weights[m] = this.weights[d] + e[g], this.momentsR[m] = this.momentsR[d] + r[g], this.momentsG[m] = this.momentsG[d] + n[g], this.momentsB[m] = this.momentsB[d] + a[g], this.moments[m] = this.moments[d] + i[g];
        }
      }
    }
  }
  createBoxes(t) {
    this.cubes = Array.from({ length: t }).fill(0).map(() => new ve());
    const e = Array.from({ length: t }).fill(0);
    this.cubes[0].r0 = 0, this.cubes[0].g0 = 0, this.cubes[0].b0 = 0, this.cubes[0].r1 = Q - 1, this.cubes[0].g1 = Q - 1, this.cubes[0].b1 = Q - 1;
    let r = t, n = 0;
    for (let a = 1; a < t; a++) {
      this.cut(this.cubes[n], this.cubes[a]) ? (e[n] = this.cubes[n].vol > 1 ? this.variance(this.cubes[n]) : 0, e[a] = this.cubes[a].vol > 1 ? this.variance(this.cubes[a]) : 0) : (e[n] = 0, a--), n = 0;
      let i = e[0];
      for (let u = 1; u <= a; u++) e[u] > i && (i = e[u], n = u);
      if (i <= 0) {
        r = a + 1;
        break;
      }
    }
    return new Be(t, r);
  }
  createResult(t) {
    const e = [];
    for (let r = 0; r < t; ++r) {
      const n = this.cubes[r], a = this.volume(n, this.weights);
      if (a > 0) {
        const i = Math.round(this.volume(n, this.momentsR) / a), u = Math.round(this.volume(n, this.momentsG) / a), f = Math.round(this.volume(n, this.momentsB) / a), p = 255 << 24 | (i & 255) << 16 | (u & 255) << 8 | f & 255;
        e.push(p);
      }
    }
    return e;
  }
  variance(t) {
    const e = this.volume(t, this.momentsR), r = this.volume(t, this.momentsG), n = this.volume(t, this.momentsB), a = this.moments[this.getIndex(t.r1, t.g1, t.b1)] - this.moments[this.getIndex(t.r1, t.g1, t.b0)] - this.moments[this.getIndex(t.r1, t.g0, t.b1)] + this.moments[this.getIndex(t.r1, t.g0, t.b0)] - this.moments[this.getIndex(t.r0, t.g1, t.b1)] + this.moments[this.getIndex(t.r0, t.g1, t.b0)] + this.moments[this.getIndex(t.r0, t.g0, t.b1)] - this.moments[this.getIndex(t.r0, t.g0, t.b0)], i = e * e + r * r + n * n, u = this.volume(t, this.weights);
    return a - i / u;
  }
  cut(t, e) {
    const r = this.volume(t, this.momentsR), n = this.volume(t, this.momentsG), a = this.volume(t, this.momentsB), i = this.volume(t, this.weights), u = this.maximize(t, j.RED, t.r0 + 1, t.r1, r, n, a, i), f = this.maximize(t, j.GREEN, t.g0 + 1, t.g1, r, n, a, i), p = this.maximize(t, j.BLUE, t.b0 + 1, t.b1, r, n, a, i);
    let l;
    const y = u.maximum, P = f.maximum, g = p.maximum;
    if (y >= P && y >= g) {
      if (u.cutLocation < 0) return false;
      l = j.RED;
    } else P >= y && P >= g ? l = j.GREEN : l = j.BLUE;
    switch (e.r1 = t.r1, e.g1 = t.g1, e.b1 = t.b1, l) {
      case j.RED:
        t.r1 = u.cutLocation, e.r0 = t.r1, e.g0 = t.g0, e.b0 = t.b0;
        break;
      case j.GREEN:
        t.g1 = f.cutLocation, e.r0 = t.r0, e.g0 = t.g1, e.b0 = t.b0;
        break;
      case j.BLUE:
        t.b1 = p.cutLocation, e.r0 = t.r0, e.g0 = t.g0, e.b0 = t.b1;
        break;
      default:
        throw new Error("unexpected direction " + l);
    }
    return t.vol = (t.r1 - t.r0) * (t.g1 - t.g0) * (t.b1 - t.b0), e.vol = (e.r1 - e.r0) * (e.g1 - e.g0) * (e.b1 - e.b0), true;
  }
  maximize(t, e, r, n, a, i, u, f) {
    const p = this.bottom(t, e, this.momentsR), l = this.bottom(t, e, this.momentsG), y = this.bottom(t, e, this.momentsB), P = this.bottom(t, e, this.weights);
    let g = 0, m = -1, d = 0, C = 0, D = 0, T = 0;
    for (let b = r; b < n; b++) {
      if (d = p + this.top(t, e, b, this.momentsR), C = l + this.top(t, e, b, this.momentsG), D = y + this.top(t, e, b, this.momentsB), T = P + this.top(t, e, b, this.weights), T === 0) continue;
      let B = (d * d + C * C + D * D) * 1, L = T * 1, M = B / L;
      d = a - d, C = i - C, D = u - D, T = f - T, T !== 0 && (B = (d * d + C * C + D * D) * 1, L = T * 1, M += B / L, M > g && (g = M, m = b));
    }
    return new Re(m, g);
  }
  volume(t, e) {
    return e[this.getIndex(t.r1, t.g1, t.b1)] - e[this.getIndex(t.r1, t.g1, t.b0)] - e[this.getIndex(t.r1, t.g0, t.b1)] + e[this.getIndex(t.r1, t.g0, t.b0)] - e[this.getIndex(t.r0, t.g1, t.b1)] + e[this.getIndex(t.r0, t.g1, t.b0)] + e[this.getIndex(t.r0, t.g0, t.b1)] - e[this.getIndex(t.r0, t.g0, t.b0)];
  }
  bottom(t, e, r) {
    switch (e) {
      case j.RED:
        return -r[this.getIndex(t.r0, t.g1, t.b1)] + r[this.getIndex(t.r0, t.g1, t.b0)] + r[this.getIndex(t.r0, t.g0, t.b1)] - r[this.getIndex(t.r0, t.g0, t.b0)];
      case j.GREEN:
        return -r[this.getIndex(t.r1, t.g0, t.b1)] + r[this.getIndex(t.r1, t.g0, t.b0)] + r[this.getIndex(t.r0, t.g0, t.b1)] - r[this.getIndex(t.r0, t.g0, t.b0)];
      case j.BLUE:
        return -r[this.getIndex(t.r1, t.g1, t.b0)] + r[this.getIndex(t.r1, t.g0, t.b0)] + r[this.getIndex(t.r0, t.g1, t.b0)] - r[this.getIndex(t.r0, t.g0, t.b0)];
      default:
        throw new Error("unexpected direction $direction");
    }
  }
  top(t, e, r, n) {
    switch (e) {
      case j.RED:
        return n[this.getIndex(r, t.g1, t.b1)] - n[this.getIndex(r, t.g1, t.b0)] - n[this.getIndex(r, t.g0, t.b1)] + n[this.getIndex(r, t.g0, t.b0)];
      case j.GREEN:
        return n[this.getIndex(t.r1, r, t.b1)] - n[this.getIndex(t.r1, r, t.b0)] - n[this.getIndex(t.r0, r, t.b1)] + n[this.getIndex(t.r0, r, t.b0)];
      case j.BLUE:
        return n[this.getIndex(t.r1, t.g1, r)] - n[this.getIndex(t.r1, t.g0, r)] - n[this.getIndex(t.r0, t.g1, r)] + n[this.getIndex(t.r0, t.g0, r)];
      default:
        throw new Error("unexpected direction $direction");
    }
  }
  getIndex(t, e, r) {
    return (t << Dt * 2) + (t << Dt + 1) + t + (e << Dt) + e + r;
  }
}
class ve {
  constructor(t = 0, e = 0, r = 0, n = 0, a = 0, i = 0, u = 0) {
    this.r0 = t, this.r1 = e, this.g0 = r, this.g1 = n, this.b0 = a, this.b1 = i, this.vol = u;
  }
}
class Be {
  constructor(t, e) {
    this.requestedCount = t, this.resultCount = e;
  }
}
class Re {
  constructor(t, e) {
    this.cutLocation = t, this.maximum = e;
  }
}
class oe {
  static quantize(t, e) {
    const n = new ae().quantize(t, e);
    return re.quantize(t, n, e);
  }
}
class rt {
  get primary() {
    return this.props.primary;
  }
  get onPrimary() {
    return this.props.onPrimary;
  }
  get primaryContainer() {
    return this.props.primaryContainer;
  }
  get onPrimaryContainer() {
    return this.props.onPrimaryContainer;
  }
  get secondary() {
    return this.props.secondary;
  }
  get onSecondary() {
    return this.props.onSecondary;
  }
  get secondaryContainer() {
    return this.props.secondaryContainer;
  }
  get onSecondaryContainer() {
    return this.props.onSecondaryContainer;
  }
  get tertiary() {
    return this.props.tertiary;
  }
  get onTertiary() {
    return this.props.onTertiary;
  }
  get tertiaryContainer() {
    return this.props.tertiaryContainer;
  }
  get onTertiaryContainer() {
    return this.props.onTertiaryContainer;
  }
  get error() {
    return this.props.error;
  }
  get onError() {
    return this.props.onError;
  }
  get errorContainer() {
    return this.props.errorContainer;
  }
  get onErrorContainer() {
    return this.props.onErrorContainer;
  }
  get background() {
    return this.props.background;
  }
  get onBackground() {
    return this.props.onBackground;
  }
  get surface() {
    return this.props.surface;
  }
  get onSurface() {
    return this.props.onSurface;
  }
  get surfaceVariant() {
    return this.props.surfaceVariant;
  }
  get onSurfaceVariant() {
    return this.props.onSurfaceVariant;
  }
  get outline() {
    return this.props.outline;
  }
  get outlineVariant() {
    return this.props.outlineVariant;
  }
  get shadow() {
    return this.props.shadow;
  }
  get scrim() {
    return this.props.scrim;
  }
  get inverseSurface() {
    return this.props.inverseSurface;
  }
  get inverseOnSurface() {
    return this.props.inverseOnSurface;
  }
  get inversePrimary() {
    return this.props.inversePrimary;
  }
  static light(t) {
    return rt.lightFromCorePalette(U.of(t));
  }
  static dark(t) {
    return rt.darkFromCorePalette(U.of(t));
  }
  static lightContent(t) {
    return rt.lightFromCorePalette(U.contentOf(t));
  }
  static darkContent(t) {
    return rt.darkFromCorePalette(U.contentOf(t));
  }
  static lightFromCorePalette(t) {
    return new rt({ primary: t.a1.tone(40), onPrimary: t.a1.tone(100), primaryContainer: t.a1.tone(90), onPrimaryContainer: t.a1.tone(10), secondary: t.a2.tone(40), onSecondary: t.a2.tone(100), secondaryContainer: t.a2.tone(90), onSecondaryContainer: t.a2.tone(10), tertiary: t.a3.tone(40), onTertiary: t.a3.tone(100), tertiaryContainer: t.a3.tone(90), onTertiaryContainer: t.a3.tone(10), error: t.error.tone(40), onError: t.error.tone(100), errorContainer: t.error.tone(90), onErrorContainer: t.error.tone(10), background: t.n1.tone(99), onBackground: t.n1.tone(10), surface: t.n1.tone(99), onSurface: t.n1.tone(10), surfaceVariant: t.n2.tone(90), onSurfaceVariant: t.n2.tone(30), outline: t.n2.tone(50), outlineVariant: t.n2.tone(80), shadow: t.n1.tone(0), scrim: t.n1.tone(0), inverseSurface: t.n1.tone(20), inverseOnSurface: t.n1.tone(95), inversePrimary: t.a1.tone(80) });
  }
  static darkFromCorePalette(t) {
    return new rt({ primary: t.a1.tone(80), onPrimary: t.a1.tone(20), primaryContainer: t.a1.tone(30), onPrimaryContainer: t.a1.tone(90), secondary: t.a2.tone(80), onSecondary: t.a2.tone(20), secondaryContainer: t.a2.tone(30), onSecondaryContainer: t.a2.tone(90), tertiary: t.a3.tone(80), onTertiary: t.a3.tone(20), tertiaryContainer: t.a3.tone(30), onTertiaryContainer: t.a3.tone(90), error: t.error.tone(80), onError: t.error.tone(20), errorContainer: t.error.tone(30), onErrorContainer: t.error.tone(80), background: t.n1.tone(10), onBackground: t.n1.tone(90), surface: t.n1.tone(10), onSurface: t.n1.tone(90), surfaceVariant: t.n2.tone(30), onSurfaceVariant: t.n2.tone(80), outline: t.n2.tone(60), outlineVariant: t.n2.tone(30), shadow: t.n1.tone(0), scrim: t.n1.tone(0), inverseSurface: t.n1.tone(90), inverseOnSurface: t.n1.tone(20), inversePrimary: t.a1.tone(40) });
  }
  constructor(t) {
    this.props = t;
  }
  toJSON() {
    return __spreadValues({}, this.props);
  }
}
class ct {
  get colorAccentPrimary() {
    return this.props.colorAccentPrimary;
  }
  get colorAccentPrimaryVariant() {
    return this.props.colorAccentPrimaryVariant;
  }
  get colorAccentSecondary() {
    return this.props.colorAccentSecondary;
  }
  get colorAccentSecondaryVariant() {
    return this.props.colorAccentSecondaryVariant;
  }
  get colorAccentTertiary() {
    return this.props.colorAccentTertiary;
  }
  get colorAccentTertiaryVariant() {
    return this.props.colorAccentTertiaryVariant;
  }
  get textColorPrimary() {
    return this.props.textColorPrimary;
  }
  get textColorSecondary() {
    return this.props.textColorSecondary;
  }
  get textColorTertiary() {
    return this.props.textColorTertiary;
  }
  get textColorPrimaryInverse() {
    return this.props.textColorPrimaryInverse;
  }
  get textColorSecondaryInverse() {
    return this.props.textColorSecondaryInverse;
  }
  get textColorTertiaryInverse() {
    return this.props.textColorTertiaryInverse;
  }
  get colorBackground() {
    return this.props.colorBackground;
  }
  get colorBackgroundFloating() {
    return this.props.colorBackgroundFloating;
  }
  get colorSurface() {
    return this.props.colorSurface;
  }
  get colorSurfaceVariant() {
    return this.props.colorSurfaceVariant;
  }
  get colorSurfaceHighlight() {
    return this.props.colorSurfaceHighlight;
  }
  get surfaceHeader() {
    return this.props.surfaceHeader;
  }
  get underSurface() {
    return this.props.underSurface;
  }
  get offState() {
    return this.props.offState;
  }
  get accentSurface() {
    return this.props.accentSurface;
  }
  get textPrimaryOnAccent() {
    return this.props.textPrimaryOnAccent;
  }
  get textSecondaryOnAccent() {
    return this.props.textSecondaryOnAccent;
  }
  get volumeBackground() {
    return this.props.volumeBackground;
  }
  get scrim() {
    return this.props.scrim;
  }
  static light(t) {
    const e = U.of(t);
    return ct.lightFromCorePalette(e);
  }
  static dark(t) {
    const e = U.of(t);
    return ct.darkFromCorePalette(e);
  }
  static lightContent(t) {
    const e = U.contentOf(t);
    return ct.lightFromCorePalette(e);
  }
  static darkContent(t) {
    const e = U.contentOf(t);
    return ct.darkFromCorePalette(e);
  }
  static lightFromCorePalette(t) {
    return new ct({ colorAccentPrimary: t.a1.tone(90), colorAccentPrimaryVariant: t.a1.tone(40), colorAccentSecondary: t.a2.tone(90), colorAccentSecondaryVariant: t.a2.tone(40), colorAccentTertiary: t.a3.tone(90), colorAccentTertiaryVariant: t.a3.tone(40), textColorPrimary: t.n1.tone(10), textColorSecondary: t.n2.tone(30), textColorTertiary: t.n2.tone(50), textColorPrimaryInverse: t.n1.tone(95), textColorSecondaryInverse: t.n1.tone(80), textColorTertiaryInverse: t.n1.tone(60), colorBackground: t.n1.tone(95), colorBackgroundFloating: t.n1.tone(98), colorSurface: t.n1.tone(98), colorSurfaceVariant: t.n1.tone(90), colorSurfaceHighlight: t.n1.tone(100), surfaceHeader: t.n1.tone(90), underSurface: t.n1.tone(0), offState: t.n1.tone(20), accentSurface: t.a2.tone(95), textPrimaryOnAccent: t.n1.tone(10), textSecondaryOnAccent: t.n2.tone(30), volumeBackground: t.n1.tone(25), scrim: t.n1.tone(80) });
  }
  static darkFromCorePalette(t) {
    return new ct({ colorAccentPrimary: t.a1.tone(90), colorAccentPrimaryVariant: t.a1.tone(70), colorAccentSecondary: t.a2.tone(90), colorAccentSecondaryVariant: t.a2.tone(70), colorAccentTertiary: t.a3.tone(90), colorAccentTertiaryVariant: t.a3.tone(70), textColorPrimary: t.n1.tone(95), textColorSecondary: t.n2.tone(80), textColorTertiary: t.n2.tone(60), textColorPrimaryInverse: t.n1.tone(10), textColorSecondaryInverse: t.n1.tone(30), textColorTertiaryInverse: t.n1.tone(50), colorBackground: t.n1.tone(10), colorBackgroundFloating: t.n1.tone(10), colorSurface: t.n1.tone(20), colorSurfaceVariant: t.n1.tone(30), colorSurfaceHighlight: t.n1.tone(35), surfaceHeader: t.n1.tone(30), underSurface: t.n1.tone(0), offState: t.n1.tone(20), accentSurface: t.a2.tone(95), textPrimaryOnAccent: t.n1.tone(10), textSecondaryOnAccent: t.n2.tone(30), volumeBackground: t.n1.tone(25), scrim: t.n1.tone(80) });
  }
  constructor(t) {
    this.props = t;
  }
  toJSON() {
    return __spreadValues({}, this.props);
  }
}
class Oe extends v {
  constructor(t, e, r, n = v.DEFAULT_SPEC_VERSION, a = v.DEFAULT_PLATFORM) {
    super({ sourceColorHct: t, variant: c.CONTENT, contrastLevel: r, isDark: e, platform: a, specVersion: n });
  }
}
class Le extends v {
  constructor(t, e, r, n = v.DEFAULT_SPEC_VERSION, a = v.DEFAULT_PLATFORM) {
    super({ sourceColorHct: t, variant: c.EXPRESSIVE, contrastLevel: r, isDark: e, platform: a, specVersion: n });
  }
}
class Me extends v {
  constructor(t, e, r, n = v.DEFAULT_SPEC_VERSION, a = v.DEFAULT_PLATFORM) {
    super({ sourceColorHct: t, variant: c.FIDELITY, contrastLevel: r, isDark: e, platform: a, specVersion: n });
  }
}
class Ne extends v {
  constructor(t, e, r, n = v.DEFAULT_SPEC_VERSION, a = v.DEFAULT_PLATFORM) {
    super({ sourceColorHct: t, variant: c.FRUIT_SALAD, contrastLevel: r, isDark: e, platform: a, specVersion: n });
  }
}
class Ve extends v {
  constructor(t, e, r, n = v.DEFAULT_SPEC_VERSION, a = v.DEFAULT_PLATFORM) {
    super({ sourceColorHct: t, variant: c.MONOCHROME, contrastLevel: r, isDark: e, platform: a, specVersion: n });
  }
}
class He extends v {
  constructor(t, e, r, n = v.DEFAULT_SPEC_VERSION, a = v.DEFAULT_PLATFORM) {
    super({ sourceColorHct: t, variant: c.NEUTRAL, contrastLevel: r, isDark: e, platform: a, specVersion: n });
  }
}
class _e extends v {
  constructor(t, e, r, n = v.DEFAULT_SPEC_VERSION, a = v.DEFAULT_PLATFORM) {
    super({ sourceColorHct: t, variant: c.RAINBOW, contrastLevel: r, isDark: e, platform: a, specVersion: n });
  }
}
class Ue extends v {
  constructor(t, e, r, n = v.DEFAULT_SPEC_VERSION, a = v.DEFAULT_PLATFORM) {
    super({ sourceColorHct: t, variant: c.TONAL_SPOT, contrastLevel: r, isDark: e, platform: a, specVersion: n });
  }
}
class ze extends v {
  constructor(t, e, r, n = v.DEFAULT_SPEC_VERSION, a = v.DEFAULT_PLATFORM) {
    super({ sourceColorHct: t, variant: c.VIBRANT, contrastLevel: r, isDark: e, platform: a, specVersion: n });
  }
}
const Ge = { desired: 4, fallbackColorARGB: 4282549748, filter: true };
function Ye(o, t) {
  return o.score > t.score ? -1 : o.score < t.score ? 1 : 0;
}
class $ {
  constructor() {
  }
  static score(t, e) {
    const { desired: r, fallbackColorARGB: n, filter: a } = __spreadValues(__spreadValues({}, Ge), e), i = [], u = new Array(360).fill(0);
    let f = 0;
    for (const [g, m] of t.entries()) {
      const d = x.fromInt(g);
      i.push(d);
      const C = Math.floor(d.hue);
      u[C] += m, f += m;
    }
    const p = new Array(360).fill(0);
    for (let g = 0; g < 360; g++) {
      const m = u[g] / f;
      for (let d = g - 14; d < g + 16; d++) {
        const C = pt(d);
        p[C] += m;
      }
    }
    const l = new Array();
    for (const g of i) {
      const m = pt(Math.round(g.hue)), d = p[m];
      if (a && (g.chroma < $.CUTOFF_CHROMA || d <= $.CUTOFF_EXCITED_PROPORTION)) continue;
      const C = d * 100 * $.WEIGHT_PROPORTION, D = g.chroma < $.TARGET_CHROMA ? $.WEIGHT_CHROMA_BELOW : $.WEIGHT_CHROMA_ABOVE, T = (g.chroma - $.TARGET_CHROMA) * D, b = C + T;
      l.push({ hct: g, score: b });
    }
    l.sort(Ye);
    const y = [];
    for (let g = 90; g >= 15; g--) {
      y.length = 0;
      for (const { hct: m } of l) if (y.find((C) => Lt(m.hue, C.hue) < g) || y.push(m), y.length >= r) break;
      if (y.length >= r) break;
    }
    const P = [];
    y.length === 0 && P.push(n);
    for (const g of y) P.push(g.toInt());
    return P;
  }
}
$.TARGET_CHROMA = 48, $.WEIGHT_PROPORTION = 0.7, $.WEIGHT_CHROMA_ABOVE = 0.3, $.WEIGHT_CHROMA_BELOW = 0.1, $.CUTOFF_CHROMA = 5, $.CUTOFF_EXCITED_PROPORTION = 0.01;
function Ut(o) {
  const t = yt(o), e = Pt(o), r = Ct(o), n = [t.toString(16), e.toString(16), r.toString(16)];
  for (const [a, i] of n.entries()) i.length === 1 && (n[a] = "0" + i);
  return "#" + n.join("");
}
function Ke(o) {
  o = o.replace("#", "");
  const t = o.length === 3, e = o.length === 6, r = o.length === 8;
  if (!t && !e && !r) throw new Error("unexpected hex " + o);
  let n = 0, a = 0, i = 0;
  return t ? (n = at(o.slice(0, 1).repeat(2)), a = at(o.slice(1, 2).repeat(2)), i = at(o.slice(2, 3).repeat(2))) : e ? (n = at(o.slice(0, 2)), a = at(o.slice(2, 4)), i = at(o.slice(4, 6))) : r && (n = at(o.slice(2, 4)), a = at(o.slice(4, 6)), i = at(o.slice(6, 8))), (255 << 24 | (n & 255) << 16 | (a & 255) << 8 | i & 255) >>> 0;
}
function at(o) {
  return parseInt(o, 16);
}
function ie() { throw new Error("ie is unavailable: it needs the browser canvas API"); }
function se(o) {
  const t = [];
  for (let a = 0; a < o.length; a += 4) {
    const i = o[a], u = o[a + 1], f = o[a + 2];
    if (o[a + 3] < 255) continue;
    const l = gt(i, u, f);
    t.push(l);
  }
  const e = oe.quantize(t, 128);
  return $.score(e)[0];
}
function ce(o, t = []) {
  const e = U.of(o);
  return { source: o, schemes: { light: rt.light(o), dark: rt.dark(o) }, palettes: { primary: e.a1, secondary: e.a2, tertiary: e.a3, neutral: e.n1, neutralVariant: e.n2, error: e.error }, customColors: t.map((r) => ue(o, r)) };
}
function $e() { throw new Error("$e is unavailable: it needs the browser canvas API"); }
function ue(o, t) {
  let e = t.value;
  const r = e, n = o;
  t.blend && (e = It.harmonize(r, n));
  const i = U.of(e).a1;
  return { color: t, value: e, light: { color: i.tone(40), onColor: i.tone(100), colorContainer: i.tone(90), onColorContainer: i.tone(10) }, dark: { color: i.tone(80), onColor: i.tone(20), colorContainer: i.tone(30), onColorContainer: i.tone(90) } };
}
function Xe(o, t) {
  var _a, _b;
  const e = (t == null ? void 0 : t.target) || document.body, n = ((_a = t == null ? void 0 : t.dark) != null ? _a : false) ? o.schemes.dark : o.schemes.light;
  if (zt(e, n), (t == null ? void 0 : t.brightnessSuffix) && (zt(e, o.schemes.dark, "-dark"), zt(e, o.schemes.light, "-light")), t == null ? void 0 : t.paletteTones) {
    const a = (_b = t == null ? void 0 : t.paletteTones) != null ? _b : [];
    for (const [i, u] of Object.entries(o.palettes)) {
      const f = i.replace(/([a-z])([A-Z])/g, "$1-$2").toLowerCase();
      for (const p of a) {
        const l = `--md-ref-palette-${f}-${f}${p}`, y = Ut(u.tone(p));
        e.style.setProperty(l, y);
      }
    }
  }
}
function zt(o, t, e = "") {
  for (const [r, n] of Object.entries(t.toJSON())) {
    const a = r.replace(/([a-z])([A-Z])/g, "$1-$2").toLowerCase(), i = Ut(n);
    o.style.setProperty(`--md-sys-color-${a}${e}`, i);
  }
}
var Blend = It;
var Cam16 = z;
var Contrast = H;
var CorePalette = U;
var DislikeAnalyzer = mt;
var DynamicColor = h;
var DynamicScheme = v;
var Hct = x;
var MaterialDynamicColors = s;
var QuantizerCelebi = oe;
var QuantizerMap = ne;
var QuantizerWsmeans = re;
var QuantizerWu = ae;
var Scheme = rt;
var SchemeAndroid = ct;
var SchemeContent = Oe;
var SchemeExpressive = Le;
var SchemeFidelity = Me;
var SchemeFruitSalad = Ne;
var SchemeMonochrome = Ve;
var SchemeNeutral = He;
var SchemeRainbow = _e;
var SchemeTonalSpot = Ue;
var SchemeVibrant = ze;
var Score = $;
var TemperatureCache = ht;
var TonalPalette = A;
var Variant = c;
var ViewingConditions = Z;
var alphaFromArgb = Vt;
var applyTheme = Xe;
var argbFromHex = Ke;
var argbFromLab = Wt;
var argbFromLinrgb = Nt;
var argbFromLstar = Jt;
var argbFromRgb = gt;
var argbFromXyz = Ht;
var blueFromArgb = Ct;
var clampDouble = Y;
var clampInt = $t;
var customColor = ue;
var delinearized = it;
var differenceDegrees = Lt;
var extendSpecVersion = F;
var greenFromArgb = Pt;
var hexFromArgb = Ut;
var isOpaque = pe;
var labFromArgb = _t;
var lerp = lt;
var linearized = et;
var lstarFromArgb = wt;
var lstarFromY = Et;
var matrixMultiply = bt;
var redFromArgb = yt;
var rotationDirection = Xt;
var sanitizeDegreesDouble = K;
var sanitizeDegreesInt = pt;
var signum = q;
var sourceColorFromImage = ie;
var sourceColorFromImageBytes = se;
var themeFromImage = $e;
var themeFromSourceColor = ce;
var whitePointD65 = Qt;
var xyzFromArgb = jt;
var yFromLstar = nt;
