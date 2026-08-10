/* Jot & Trot service worker.
   The app is one HTML file and already keeps trip DATA offline in localStorage;
   this worker only makes the SHELL loadable offline. Strategy: network-first
   for navigations (always fresh online, cached copy offline), no caching of
   API or tile traffic (Supabase needs liveness; Geoapify tiles eat quota). */
const CACHE = "jj-shell-v1";
const SHELL = "/index.html";

self.addEventListener("install", (e) => {
  e.waitUntil(caches.open(CACHE).then((c) => c.add(SHELL)).then(() => self.skipWaiting()));
});

self.addEventListener("activate", (e) => {
  e.waitUntil((async () => {
    for (const k of await caches.keys()) if (k !== CACHE) await caches.delete(k);
    await self.clients.claim();
  })());
});

/* Web Push: same "Leslie added 3 stops" alerts the iPhones get */
self.addEventListener("push", (e) => {
  let data = {};
  try { data = e.data ? e.data.json() : {}; } catch (err) { data = { body: e.data && e.data.text() }; }
  e.waitUntil(self.registration.showNotification(data.title || "Jot & Trot", {
    body: data.body || "",
    icon: "/icons/icon-192.png",
    badge: "/icons/icon-192.png",
    tag: "jj-trip",
  }));
});
self.addEventListener("notificationclick", (e) => {
  e.notification.close();
  e.waitUntil((async () => {
    const wins = await clients.matchAll({ type: "window", includeUncontrolled: true });
    if (wins.length) return wins[0].focus();
    return clients.openWindow("/");
  })());
});

self.addEventListener("fetch", (e) => {
  const url = new URL(e.request.url);
  if (e.request.mode === "navigate") {
    // any in-app navigation (/, /join/x, /plan/x) serves the shell
    e.respondWith((async () => {
      try {
        const fresh = await fetch(e.request);
        const copy = fresh.clone();
        caches.open(CACHE).then((c) => c.put(SHELL, copy));
        return fresh;
      } catch (err) {
        return (await caches.match(SHELL)) || Response.error();
      }
    })());
    return;
  }
  // same-origin static bits (icons, manifest): cache-first, they rarely change
  if (url.origin === location.origin && (url.pathname.startsWith("/icons/") || url.pathname.endsWith(".webmanifest"))) {
    e.respondWith((async () => {
      const hit = await caches.match(e.request);
      if (hit) return hit;
      const res = await fetch(e.request);
      caches.open(CACHE).then((c) => c.put(e.request, res.clone()));
      return res;
    })());
  }
});
