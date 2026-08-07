const { chromium } = require('playwright');
const { execFileSync } = require('child_process');
function curlFetch(request) {
  const args = ['-s','-i','--max-time','25','-X',request.method()];
  if (!request.url().includes('geoapify')) args.push('-A','Mozilla/5.0 TripArchitectTest');
  const h = request.headers();
  for (const k of ['apikey','authorization','content-type','prefer','accept']) if (h[k]) args.push('-H', `${k}: ${h[k]}`);
  if (request.postData()) args.push('--data-binary', request.postData());
  args.push(request.url());
  let buf = execFileSync('curl', args, { maxBuffer: 64*1024*1024 });
  let status = 200, headers = {};
  while (true) {
    const idx = buf.indexOf('\r\n\r\n');
    const lines = buf.slice(0, idx).toString().split('\r\n');
    status = parseInt(lines[0].split(' ')[1], 10);
    headers = {};
    for (const l of lines.slice(1)) { const c = l.indexOf(':'); if (c > 0) headers[l.slice(0,c).trim().toLowerCase()] = l.slice(c+1).trim(); }
    buf = buf.slice(idx + 4);
    if (status !== 100 && !buf.slice(0,5).toString().startsWith('HTTP/')) break;
  }
  for (const k of ['transfer-encoding','content-encoding','content-length']) delete headers[k];
  return { status, headers, body: buf };
}
async function phonePage(browser, dark) {
  const context = await browser.newContext({ viewport: { width: 393, height: 852 }, isMobile: true, hasTouch: true, deviceScaleFactor: 2, colorScheme: dark ? 'dark' : 'light' });
  const handler = async route => { try { await route.fulfill(curlFetch(route.request())); } catch (e) { try { await route.abort(); } catch (e2) {} } };
  for (const pat of ['**://vlmqbskqyvutbrmhfvuv.supabase.co/**','**://api.geoapify.com/**','**://maps.geoapify.com/**']) await context.route(pat, handler);
  const page = await context.newPage();
  await page.goto('file:///home/claude/trip-architect/jotandtrot.html');
  await page.waitForFunction(() => typeof sb !== 'undefined', null, { timeout: 15000, polling: 300 });
  await page.evaluate(async () => {
    const { data } = await sb.auth.signInWithPassword({ email: 'jj-shot@example.com', password: 'JJtest!2026pass' });
    await onSignedIn(data.user);
  });
  await page.waitForTimeout(3000);
  await page.evaluate(() => closeModal());
  return page;
}
(async () => {
  const browser = await chromium.launch({ executablePath: '/opt/pw-browsers/chromium', args: ['--no-sandbox'] });
  // light mode: map + plan
  let p = await phonePage(browser, false);
  await p.evaluate(async () => {
    const t = window.__ta.trips[0];
    await sb.from('trip_trips').update({ name: 'Lisbon Long Weekend' }).eq('id', t.id);
    t.name = 'Lisbon Long Weekend';
    await openTrip(t.id);
  });
  await p.waitForTimeout(3000);
  await p.evaluate(() => {
    const pts = [];
    state.map.eachLayer(l => { if (l.getLatLng) { const ll = l.getLatLng(); if (ll.lng > -9.3) pts.push([ll.lat, ll.lng]); } });
    state.map.fitBounds(pts, { padding: [60, 60] });
  });
  await p.waitForTimeout(22000);
  await p.screenshot({ path: 'docs_map_light.png' });
  await p.tap('#mn-plan');
  await p.waitForTimeout(1200);
  await p.screenshot({ path: 'docs_plan_light.png' });
  await p.context().close();
  // dark mode: map
  p = await phonePage(browser, true);
  await p.evaluate(async () => { const t = window.__ta.trips[0]; await openTrip(t.id); });
  await p.waitForTimeout(3000);
  await p.evaluate(() => {
    const pts = [];
    state.map.eachLayer(l => { if (l.getLatLng) { const ll = l.getLatLng(); if (ll.lng > -9.3) pts.push([ll.lat, ll.lng]); } });
    state.map.fitBounds(pts, { padding: [60, 60] });
  });
  await p.waitForTimeout(22000);
  await p.screenshot({ path: 'docs_map_dark.png' });
  await p.context().close();
  console.log('shots done');
  await browser.close();
})().catch(e => { console.error('FATAL', e.message); process.exit(1); });
