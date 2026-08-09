// App Store screenshots at 6.9" (1290×2796): viewport 430×932 @3x.
// Reuses the jj-shot demo account and its Lisbon trip, like shots.js.
const { chromium } = require('playwright');
const { execFileSync } = require('child_process');
const path = require('path');

function curlFetch(request) {
  const args = ['-s', '-i', '--max-time', '25', '-X', request.method()];
  if (!request.url().includes('geoapify')) args.push('-A', 'Mozilla/5.0 TripArchitectTest');
  const h = request.headers();
  for (const k of ['apikey', 'authorization', 'content-type', 'prefer', 'accept']) if (h[k]) args.push('-H', `${k}: ${h[k]}`);
  if (request.postData()) args.push('--data-binary', request.postData());
  args.push(request.url());
  let buf = execFileSync('curl', args, { maxBuffer: 64 * 1024 * 1024 });
  let status = 200, headers = {};
  while (true) {
    const idx = buf.indexOf('\r\n\r\n');
    const lines = buf.slice(0, idx).toString().split('\r\n');
    status = parseInt(lines[0].split(' ')[1], 10);
    headers = {};
    for (const l of lines.slice(1)) { const c = l.indexOf(':'); if (c > 0) headers[l.slice(0, c).trim().toLowerCase()] = l.slice(c + 1).trim(); }
    buf = buf.slice(idx + 4);
    if (status !== 100 && !buf.slice(0, 5).toString().startsWith('HTTP/')) break;
  }
  for (const k of ['transfer-encoding', 'content-encoding', 'content-length']) delete headers[k];
  return { status, headers, body: buf };
}

async function phonePage(browser, dark) {
  const context = await browser.newContext({
    viewport: { width: 430, height: 932 }, isMobile: true, hasTouch: true,
    deviceScaleFactor: 3, colorScheme: dark ? 'dark' : 'light',
  });
  const handler = async route => { try { await route.fulfill(curlFetch(route.request())); } catch (e) { try { await route.abort(); } catch (e2) {} } };
  for (const pat of ['**://vlmqbskqyvutbrmhfvuv.supabase.co/**', '**://api.geoapify.com/**', '**://maps.geoapify.com/**', '**://api.open-meteo.com/**'])
    await context.route(pat, handler);
  const page = await context.newPage();
  await page.goto('file://' + path.join(__dirname, 'jotandtrot.html'));
  await page.waitForFunction(() => typeof sb !== 'undefined', null, { timeout: 15000, polling: 300 });
  await page.evaluate(async () => {
    const { data, error } = await sb.auth.signInWithPassword({ email: 'jj-shot@example.com', password: 'JJtest!2026pass' });
    if (error) throw new Error('demo sign-in failed: ' + error.message);
    await onSignedIn(data.user);
  });
  await page.waitForTimeout(3000);
  await page.evaluate(() => closeModal());
  return page;
}

const fitLisbon = () => {
  const pts = [];
  state.map.eachLayer(l => { if (l.getLatLng) { const ll = l.getLatLng(); if (ll.lng > -9.3) pts.push([ll.lat, ll.lng]); } });
  if (pts.length) state.map.fitBounds(pts, { padding: [60, 60] });
};

(async () => {
  const browser = await chromium.launch({ args: ['--no-sandbox'] });

  if (process.env.IPAD) {
    // 13" iPad: 2064×2752 portrait — the app's wide layout (map + plan together)
    const context = await browser.newContext({ viewport: { width: 1032, height: 1376 }, deviceScaleFactor: 2, colorScheme: 'light' });
    const handler = async route => { try { await route.fulfill(curlFetch(route.request())); } catch (e) { try { await route.abort(); } catch (e2) {} } };
    for (const pat of ['**://vlmqbskqyvutbrmhfvuv.supabase.co/**', '**://api.geoapify.com/**', '**://maps.geoapify.com/**', '**://api.open-meteo.com/**'])
      await context.route(pat, handler);
    const page = await context.newPage();
    await page.goto('file://' + path.join(__dirname, 'jotandtrot.html'));
    await page.waitForFunction(() => typeof sb !== 'undefined', null, { timeout: 15000, polling: 300 });
    await page.evaluate(async () => {
      const { data, error } = await sb.auth.signInWithPassword({ email: 'jj-shot@example.com', password: 'JJtest!2026pass' });
      if (error) throw new Error('demo sign-in failed: ' + error.message);
      await onSignedIn(data.user);
    });
    await page.waitForTimeout(3000);
    await page.evaluate(() => closeModal());
    await page.evaluate(async () => { const t = window.__ta.trips.find(x => x.name === 'Example: Lisbon Long Weekend') || window.__ta.trips[0]; await openTrip(t.id); });
    await page.waitForTimeout(4000);
    await page.evaluate(fitLisbon);
    await page.waitForTimeout(20000);
    await page.screenshot({ path: '/tmp/as-ipad1.png' });
    await context.close();
    console.log('ipad shot done');
    await browser.close();
    return;
  }

  // ----- light mode: map, plan, today -----
  let p = await phonePage(browser, false);
  await p.evaluate(async () => {
    const t = window.__ta.trips.find(x => x.name === 'Lisbon Long Weekend') || window.__ta.trips[0];
    // dates: today through +3, so the Today view is live for the shot
    const d = (n) => { const x = new Date(Date.now() + n * 86400000); return `${x.getFullYear()}-${String(x.getMonth() + 1).padStart(2, '0')}-${String(x.getDate()).padStart(2, '0')}`; };
    await sb.from('trip_trips').update({ start_date: d(0), end_date: d(3) }).eq('id', t.id);
    await openTrip(t.id);
  });
  await p.waitForTimeout(4000);
  await p.evaluate(fitLisbon);
  await p.waitForTimeout(20000);
  await p.screenshot({ path: '/tmp/as1-map.png' });

  await p.tap('#mn-plan');
  await p.waitForTimeout(4000);  // travel legs + weather land async
  await p.screenshot({ path: '/tmp/as2-plan-today.png' });

  // scroll past the today hero to show day sections with travel legs
  await p.evaluate(() => { const el = document.querySelector('.day-section[data-day="2"]'); if (el) el.scrollIntoView({ block: 'start' }); });
  await p.waitForTimeout(800);
  await p.screenshot({ path: '/tmp/as3-plan-days.png' });
  await p.context().close();

  // ----- dark mode: map -----
  p = await phonePage(browser, true);
  await p.evaluate(async () => { const t = window.__ta.trips.find(x => x.name === 'Lisbon Long Weekend') || window.__ta.trips[0]; await openTrip(t.id); });
  await p.waitForTimeout(4000);
  await p.evaluate(fitLisbon);
  await p.waitForTimeout(20000);
  await p.screenshot({ path: '/tmp/as4-map-dark.png' });
  await p.context().close();

  console.log('app store shots done');
  await browser.close();
})().catch(e => { console.error('FATAL', e.message); process.exit(1); });
