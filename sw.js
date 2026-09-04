const CACHE = 'doogie-v20';
const ASSETS = ['./','./index.html','./background.jpg','./manifest.webmanifest','./apple-touch-icon.png','./audio/hello.mp3','./audio/start.mp3','./audio/inhale.mp3','./audio/hold.mp3','./audio/exhale.mp3','./audio/done.mp3','./audio/morning.mp3','./audio/afternoon.mp3','./audio/evening.mp3','./audio/night.mp3'];
self.addEventListener('install', event => {
  event.waitUntil(caches.open(CACHE).then(cache => cache.addAll(ASSETS)).then(() => self.skipWaiting()));
});
self.addEventListener('activate', event => {
  event.waitUntil(caches.keys().then(keys => Promise.all(keys.filter(k => k !== CACHE).map(k => caches.delete(k)))).then(() => self.clients.claim()));
});
self.addEventListener('fetch', event => {
  if (event.request.method !== 'GET') return;
  event.respondWith(caches.match(event.request).then(cached => cached || fetch(event.request).then(response => {
    const copy = response.clone();
    if (new URL(event.request.url).origin === location.origin) caches.open(CACHE).then(c => c.put(event.request, copy));
    return response;
  }).catch(() => caches.match('./index.html'))));
});
