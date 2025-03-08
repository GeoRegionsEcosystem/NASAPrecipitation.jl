import{_ as e,c as a,o as l,aA as d}from"./chunks/framework.CuUjZ80-.js";const p=JSON.parse('{"title":"Available NASA Precipitation Datasets","description":"","frontmatter":{},"headers":[],"relativePath":"datasets/intro.md","filePath":"datasets/intro.md","lastUpdated":null}'),n={name:"datasets/intro.md"};function i(o,t,r,s,c,y){return l(),a("div",null,t[0]||(t[0]=[d('<h1 id="Available-NASA-Precipitation-Datasets" tabindex="-1">Available NASA Precipitation Datasets <a class="header-anchor" href="#Available-NASA-Precipitation-Datasets" aria-label="Permalink to &quot;Available NASA Precipitation Datasets {#Available-NASA-Precipitation-Datasets}&quot;">​</a></h1><p>A NASA Precipitation Dataset is defined to be a dataset from the NASA Global Precipitation Measurement (GPM) Mission. As of now, NASAPrecipitation.jl supports the following <strong>Level 3</strong> products:</p><ul><li><p><strong>GPM IMERGv6</strong>, 0.1º resolution, 60ºS to 60ºN</p><ul><li><p>Final runs for Half-Hourly, Daily and Monthly Data</p></li><li><p>Early and Late runs of Half-Hourly and Daily Data</p></li></ul></li><li><p><strong>TRMM TMPAv7</strong>, 0.25º resolution, 50ºS to 50ºN</p><ul><li><p>Final runs for 3-Hourly, Daily and Monthly Data</p></li><li><p>Near Real-Time runs of 3-Hourly and Daily Data</p></li></ul></li></ul><p>The <code>NASAPrecipitationDataset</code> Type has two sub-Types:</p><ul><li><p>The <code>IMERGDataset</code> for the GPM IMERG Dataset</p></li><li><p>The <code>TRMMDataset</code> for the TRMM TMPA Dataset</p></li></ul><p>Each of these Abstract superTypes has its own set of Types. See the summary table below for an overview, and the respective pages for <a href="./imerg">GPM IMERG</a> and <a href="./trmm">TRMM TMPA</a> for more information.</p><p>All subTypes of the <code>NASAPrecipitationDataset</code> have the <a href="/NASAPrecipitation.jl/dev/basics#NASAPrecipitation.NASAPrecipitationDataset">same basic fields and structure</a>.</p><h2 id="Summary-Table" tabindex="-1">Summary Table <a class="header-anchor" href="#Summary-Table" aria-label="Permalink to &quot;Summary Table {#Summary-Table}&quot;">​</a></h2><p>The following are the different available Types and functions used to <a href="./define">define</a> them:</p><table tabindex="0"><thead><tr><th style="text-align:center;"></th><th style="text-align:center;"><code>SuperType</code></th><th style="text-align:center;"><code>Type</code></th><th style="text-align:center;">Early</th><th style="text-align:center;">Late / NRT</th><th style="text-align:center;">Final NRT</th></tr></thead><tbody><tr><td style="text-align:center;">IMERG 30 Mins</td><td style="text-align:center;"><code>IMERGDataset</code></td><td style="text-align:center;"><code>IMERGHalfHourly</code></td><td style="text-align:center;"><code>IMERGEarlyHH()</code></td><td style="text-align:center;"><code>IMERGLateHH()</code></td><td style="text-align:center;"><code>IMERGFinalHH()</code></td></tr><tr><td style="text-align:center;">IMERG Daily</td><td style="text-align:center;"><code>IMERGDataset</code></td><td style="text-align:center;"><code>IMERGDaily</code></td><td style="text-align:center;"><code>IMERGEarlyDY()</code></td><td style="text-align:center;"><code>IMERGLateDY()</code></td><td style="text-align:center;"><code>IMERGFinalDY()</code></td></tr><tr><td style="text-align:center;">IMERG Monthly</td><td style="text-align:center;"><code>IMERGDataset</code></td><td style="text-align:center;"><code>IMERGMonthly</code></td><td style="text-align:center;"></td><td style="text-align:center;"></td><td style="text-align:center;"><code>IMERGMonthly()</code></td></tr><tr><td style="text-align:center;">TRMM 3 Hour</td><td style="text-align:center;"><code>TRMMDataset</code></td><td style="text-align:center;"><code>TRMM3Hourly</code></td><td style="text-align:center;"></td><td style="text-align:center;"><code>TRMM3HourlyNRT()</code></td><td style="text-align:center;"><code>TRMM3Hourly()</code></td></tr><tr><td style="text-align:center;">TRMM Daily</td><td style="text-align:center;"><code>TRMMDataset</code></td><td style="text-align:center;"><code>TRMMDaily</code></td><td style="text-align:center;"></td><td style="text-align:center;"><code>TRMMDailyNRT()</code></td><td style="text-align:center;"><code>TRMMDaily()</code></td></tr><tr><td style="text-align:center;">TRMM Monthly</td><td style="text-align:center;"><code>TRMMDataset</code></td><td style="text-align:center;"><code>TRMMMonthly</code></td><td style="text-align:center;"></td><td style="text-align:center;"></td><td style="text-align:center;"><code>TRMMMonthly()</code></td></tr></tbody></table>',10)]))}const h=e(n,[["render",i]]);export{p as __pageData,h as default};
