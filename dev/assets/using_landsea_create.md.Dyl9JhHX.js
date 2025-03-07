import{_ as t,C as p,c as l,o as h,aA as i,j as s,G as e,a as d,w as o}from"./chunks/framework.CuUjZ80-.js";const b=JSON.parse('{"title":"Loading and Saving Land-Sea Mask Datasets","description":"","frontmatter":{},"headers":[],"relativePath":"using/landsea/create.md","filePath":"using/landsea/create.md","lastUpdated":null}'),r={name:"using/landsea/create.md"},k={class:"jldocstring custom-block",open:""};function c(g,a,u,E,m,y){const n=p("Badge");return h(),l("div",null,[a[4]||(a[4]=i(`<h1 id="Loading-and-Saving-Land-Sea-Mask-Datasets" tabindex="-1">Loading and Saving Land-Sea Mask Datasets <a class="header-anchor" href="#Loading-and-Saving-Land-Sea-Mask-Datasets" aria-label="Permalink to &quot;Loading and Saving Land-Sea Mask Datasets {#Loading-and-Saving-Land-Sea-Mask-Datasets}&quot;">​</a></h1><p>The Land-Sea Dataset can be obtained using the function <code>getLandSea()</code>. See end of the page for the API</p><h3 id="setup" tabindex="-1">Setup <a class="header-anchor" href="#setup" aria-label="Permalink to &quot;Setup&quot;">​</a></h3><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">using</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> NASAPrecipitation</span></span>
<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">using</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> DelimitedFiles</span></span>
<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">using</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> CairoMakie</span></span>
<span class="line"></span>
<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">download</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;https://raw.githubusercontent.com/natgeo-wong/GeoPlottingData/main/coastline_resl.txt&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">,</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;coast.cst&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">coast </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> readdlm</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;coast.cst&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">,comments</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">true</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">clon  </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> coast[:,</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">1</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">]</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">clat  </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> coast[:,</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">2</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">]</span></span>
<span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">nothing</span></span></code></pre></div><h2 id="Retrieving-IMERG-and-TRMM-Land-Sea-Mask-over-Java" tabindex="-1">Retrieving IMERG and TRMM Land-Sea Mask over Java <a class="header-anchor" href="#Retrieving-IMERG-and-TRMM-Land-Sea-Mask-over-Java" aria-label="Permalink to &quot;Retrieving IMERG and TRMM Land-Sea Mask over Java {#Retrieving-IMERG-and-TRMM-Land-Sea-Mask-over-Java}&quot;">​</a></h2><p>First, we must define the <code>NASAPrecipitation</code> datasets, and the GeoRegion of interest.</p><div class="language-@example vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">@example</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>npd_imerg = IMERGDummy(path=pwd())</span></span>
<span class="line"><span>npd_trmm  = TRMMDummy(path=pwd())</span></span>
<span class="line"><span>geo  = RectRegion(&quot;JAV&quot;,&quot;GLB&quot;,&quot;Java&quot;,[-5.5,-9,115,105],savegeo=false)</span></span></code></pre></div><p>Then, we retrieve the IMERG LandSea Dataset</p><div class="language-@example vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">@example</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>lsd_imerg = getLandSea(npd_imerg,geo)</span></span></code></pre></div><p>And then the TRMM LandSea Dataset</p><div class="language-@example vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">@example</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>lsd_trmm  = getLandSea(npd_trmm ,geo)</span></span></code></pre></div><p>And we plot them below for comparison:</p><div class="language-@example vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">@example</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>fig = Figure()</span></span>
<span class="line"><span>slon,slat = coordGeoRegion(geo)</span></span>
<span class="line"><span>aspect = (maximum(slon)-minimum(slon))/(maximum(slat)-minimum(slat))</span></span>
<span class="line"><span></span></span>
<span class="line"><span>ax1 = Axis(</span></span>
<span class="line"><span>    fig[1,1],width=750,height=750/aspect,</span></span>
<span class="line"><span>    title=&quot;IMERG Land-Sea Mask&quot;,ylabel=&quot;Latitude / º&quot;,</span></span>
<span class="line"><span>    limits=(minimum(slon)-0.5,maximum(slon)+0.5,minimum(slat)-0.5,maximum(slat)+0.5)</span></span>
<span class="line"><span>)</span></span>
<span class="line"><span>contourf!(</span></span>
<span class="line"><span>    ax1,lsd_imerg.lon,lsd_imerg.lat,lsd_imerg.lsm,colormap=:delta,</span></span>
<span class="line"><span>    levels=range(0.05,0.95,length=19),extendlow=:auto,extendhigh=:auto</span></span>
<span class="line"><span>)</span></span>
<span class="line"><span>lines!(ax1,slon,slat,linewidth=5)</span></span>
<span class="line"><span></span></span>
<span class="line"><span>ax2 = Axis(</span></span>
<span class="line"><span>    fig[2,1],width=750,height=750/aspect,</span></span>
<span class="line"><span>    title=&quot;TRMM Land-Sea Mask&quot;,xlabel=&quot;Longitude / º&quot;,ylabel=&quot;Latitude / º&quot;,</span></span>
<span class="line"><span>    limits=(minimum(slon)-0.5,maximum(slon)+0.5,minimum(slat)-0.5,maximum(slat)+0.5)</span></span>
<span class="line"><span>)</span></span>
<span class="line"><span>contourf!(</span></span>
<span class="line"><span>    ax2,lsd_trmm.lon,lsd_trmm.lat,lsd_trmm.lsm,colormap=:delta,</span></span>
<span class="line"><span>    levels=range(0.05,0.95,length=19),extendlow=:auto,extendhigh=:auto</span></span>
<span class="line"><span>)</span></span>
<span class="line"><span>lines!(ax2,slon,slat,linewidth=5)</span></span>
<span class="line"><span></span></span>
<span class="line"><span>resize_to_layout!(fig)</span></span>
<span class="line"><span>fig</span></span></code></pre></div><p>We see that, as expected, the IMERG <code>LandSea</code> dataset is of a higher resolution than that of TRMM, which also explains the gap between the border of the GeoRegion and the data, because in GPM IMERG and TRMM TMPA datasets, the grid <em>edges</em> start at [ N,S,E,W ] = [ 90,-90,360,0 ], not the grid centers.</p><h2 id="api" tabindex="-1">API <a class="header-anchor" href="#api" aria-label="Permalink to &quot;API&quot;">​</a></h2>`,15)),s("details",k,[s("summary",null,[a[0]||(a[0]=s("a",{id:"LandSea.getLandSea",href:"#LandSea.getLandSea"},[s("span",{class:"jlbinding"},"LandSea.getLandSea")],-1)),a[1]||(a[1]=d()),e(n,{type:"info",class:"jlObjectType jlFunction",text:"Function"})]),a[3]||(a[3]=i(`<div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">getLandSea</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    npd </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> NASAPrecipitationDataset</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">,</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    geo </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">::</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> GeoRegion</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;"> =</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> GeoRegion</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;GLB&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">);</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    returnlsd </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> true</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">,</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    FT </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> Float32</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">) </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">-&gt;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> LandSea</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">.</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">LandSeaFlat</span></span></code></pre></div><p>Retrieve the Land-Sea Mask data for the <code>NASAPrecipitationDataset</code> specified.</p><p><strong>Arguments</strong></p><ul><li><p><code>npd</code> : The <code>NASAPrecipitationDataset</code> specified, can be either IMERG or TRMM, the function will download the relevant Land-Sea mask without needing further specification.</p></li><li><p><code>geo</code> : The GeoRegion of interest</p></li></ul><p><strong>Keyword Arguments</strong></p><ul><li><code>returnlsd</code> : If <code>true</code> return the data as a <code>LandSea.LandSeaFlat</code> dataset. Otherwise, the data is simply saved into the npd.maskpath directory.</li></ul>`,6)),e(n,{type:"info",class:"source-link",text:"source"},{default:o(()=>a[2]||(a[2]=[s("a",{href:"https://github.com/GeoRegionsEcosystem/NASAPrecipitation.jl/blob/8d4bf18161de83213417edb380f1b0c4990440ac/src/landsea/imerg.jl#L1-L19",target:"_blank",rel:"noreferrer"},"source",-1)])),_:1})])])}const F=t(r,[["render",c]]);export{b as __pageData,F as default};
