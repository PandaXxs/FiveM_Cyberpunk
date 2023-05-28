import{r,a as C,j as o}from"./jsx-runtime-7cf68bf7.js";import{aa as _,a8 as y,u as b,f as A,aH as L,B as S,L as n,bp as Y,bq as U,q as w,br as x,bs as I,C as g,N as B,b as k}from"./Phone-ec5c0d3e.js";function $({children:e,text:t}){const[d,h]=r.useState(!1);return C("div",{className:"tooltip-wrapper",onMouseEnter:()=>h(!0),onMouseLeave:()=>h(!1),children:[e,o(_,{children:d&&o(y.div,{initial:{opacity:0},animate:{opacity:1},exit:{opacity:0},transition:{duration:.3,ease:"easeInOut"},className:"tooltip top",children:o("div",{dangerouslySetInnerHTML:{__html:t}})})})]})}const N=r.createContext(null);function z(){var m;const e=b(B),t=b(k.Settings),[d,h]=r.useState(0),[p,T]=r.useState([]),[O,i]=r.useState(""),[c,P]=r.useState("0"),[s,l]=r.useState(t==null?void 0:t.streamerMode);r.useEffect(()=>{A("Crypto",{action:"get"}).then(a=>{a&&T(a)})},[]),r.useEffect(()=>h(p.reduce((a,v)=>a+(v.owned??0)*v.current_price,0)),[p]),r.useEffect(()=>{P(s?L("∗".repeat(S(d,2).toString().length)):L(S(d,2)))},[d,s]);const u=a=>{let v={0:50,10:45,12:40,14:35},E=0;for(let f=0;f<Object.keys(v).length;f++)a.length>=parseInt(Object.keys(v)[f])&&(E=v[Object.keys(v)[f]]);return E};return C("div",{className:"crypto-container",children:[C("div",{className:"crypto-header",children:[o("img",{src:"./assets/img/icons/apps/Cryptopng.png",alt:"btc"}),n("APPS.CRYPTO.TITLE")]}),o(N.Provider,{value:{Coins:[p,T]},children:C("div",{className:"crypto-wrapper",children:[C("div",{className:"balance",children:[C("div",{className:"title",children:[n("APPS.CRYPTO.BALANCE"),o("div",{className:"icon",onClick:()=>l(!s),children:s?o(Y,{}):o(U,{})})]}),o("div",{className:"amount",style:{fontSize:u(c.toString())},onClick:()=>l(!s),children:(m=e==null?void 0:e.CurrencyFormat)==null?void 0:m.replace("%s",c.toString())})]}),o("div",{className:"search",children:o(w,{placeholder:"Search Cryptocurrency",onChange:a=>i(a.target.value)})}),o(D,{search:O}),o("div",{className:"credits",children:"Powered by CoinGecko"})]})})]})}const D=({search:e})=>{const[t,d]=r.useState("balance"),[h,p]=r.useState(!0),T=["Name","Graph","Balance"],[O]=r.useContext(N).Coins;return o("div",{className:"holdings",children:C("div",{className:"items",children:[o("div",{className:"item filters",children:T.map((i,c)=>C("div",{className:"filter",onClick:()=>{if(d(i.toLowerCase()),t===i.toLowerCase())return p(!h);p(!0)},children:[i,i.toLowerCase()===t&&h?o(x,{}):o(I,{})]},c))}),O.sort((i,c)=>t==="name"?h?i.name.localeCompare(c.name):c.name.localeCompare(i.name):t==="graph"?h?i.change_24h-c.change_24h:c.change_24h-i.change_24h:t==="balance"?h?(c.owned??0)*c.current_price-(i.owned??0)*i.current_price:(i.owned??0)*i.current_price-(c.owned??0)*c.current_price:0).filter(i=>i.name.toLowerCase().includes(e.toLowerCase())||i.symbol.toLowerCase().includes(e.toLowerCase())).map((i,c)=>o(j,{data:i},c))]})})},j=({data:e})=>{const[t,d]=r.useState(!1),[h,p]=r.useState(""),[T,O]=r.useContext(N).Coins,i=(P,s)=>{s>1?A("Crypto",{action:"buy",coin:P,amount:s}).then(l=>{if(l!=null&&l.success)return O(u=>u.map(m=>m.id===P?{...m,owned:(m.owned??0)+s/m.current_price,value:(m.value??0)+s,invested:(m.invested??0)+s}:m));l!=null&&l.msg&&setTimeout(()=>{g.PopUp.set({title:n("APPS.CRYPTO.ERROR"),description:n(`APPS.CRYPTO.${l.msg}`),buttons:[{title:n("APPS.CRYPTO.CLOSE")}]})},250)}):setTimeout(()=>{g.PopUp.set({title:n("APPS.CRYPTO.ERROR"),description:n("APPS.CRYPTO.ATLEAST_ONE_COIN").format({action:"buy"}),buttons:[{title:n("APPS.CRYPTO.CLOSE")}]})},250)},c=(P,s,l)=>{l>0?A("Crypto",{action:"sell",coin:P,amount:l}).then(u=>{if(u!=null&&u.success)return O(m=>m.map(a=>a.id===P?{...a,owned:(a.owned??0)-s/a.current_price,value:(a.value??0)+s,invested:(a.invested??0)-s}:a));u!=null&&u.msg&&setTimeout(()=>{g.PopUp.set({title:n("APPS.CRYPTO.ERROR"),description:n(`APPS.CRYPTO.${u.msg}`),buttons:[{title:n("APPS.CRYPTO.CLOSE")}]})},250)}):setTimeout(()=>{g.PopUp.set({title:n("APPS.CRYPTO.ERROR"),description:n("APPS.CRYPTO.ATLEAST_ONE_COIN").format({action:"sell"}),buttons:[{title:n("APPS.CRYPTO.CLOSE")}]})},250)};return e.symbol=e.symbol.toUpperCase(),e.owned=e.owned??0,e.value=e.current_price*(e.owned??0),C("div",{className:"item",onClick:()=>d(!t),children:[C("div",{className:"top",children:[C("div",{className:"info",children:[o("img",{src:e.image,className:"icon",alt:"Icon"}),C("div",{className:"coin",children:[o("div",{className:"name",children:e.symbol}),o("div",{className:"symbol",children:e.name})]})]}),o(F,{data:e}),C("div",{className:"amount",children:[o("div",{className:"value",children:L(S(e.owned,4))}),C("div",{className:"asset",children:["$",L(S(e.value,2))]})]})]}),o(_,{children:t&&C(y.div,{initial:{height:0},animate:{height:"auto"},exit:{height:0},className:"bottom",children:[o(y.div,{initial:{opacity:0},animate:{opacity:1},exit:{opacity:0},transition:{duration:.1},className:"button fill",onClick:P=>{P.stopPropagation(),g.PopUp.set({title:n("APPS.CRYPTO.BUY_POPUP.TITLE").format({coin:e.symbol}),description:n("APPS.CRYPTO.BUY_POPUP.DESCRIPTION").format({coin:e.symbol}),input:{placeholder:n("APPS.CRYPTO.BUY_POPUP.PLACEHOLDER"),type:"number",value:0,onChange:s=>p(s)},buttons:[{title:n("APPS.CRYPTO.BUY_POPUP.CANCEL")},{title:n("APPS.CRYPTO.BUY_POPUP.PROCEED"),cb:()=>{p(s=>(i(e.id,parseFloat(s)),s))}}]})},children:n("APPS.CRYPTO.BUY")}),o(y.div,{initial:{opacity:0},animate:{opacity:1},exit:{opacity:0},transition:{duration:.1},className:"button",onClick:P=>{P.stopPropagation(),g.PopUp.set({title:n("APPS.CRYPTO.SELL_POPUP.TITLE").format({coin:e.symbol}),description:n("APPS.CRYPTO.SELL_POPUP.DESCRIPTION").format({coin:e.symbol}),input:{placeholder:n("APPS.CRYPTO.BUY_POPUP.PLACEHOLDER"),type:"number",value:0,onChange:s=>p(s)},buttons:[{title:n("APPS.CRYPTO.BUY_POPUP.CANCEL")},{title:n("APPS.CRYPTO.BUY_POPUP.PROCEED"),cb:()=>{p(s=>{let l=parseFloat(s),u=l/e.current_price;return c(e.id,l,u),s})}}]})},children:n("APPS.CRYPTO.SELL")}),o(y.div,{initial:{opacity:0},animate:{opacity:1},exit:{opacity:0},transition:{duration:.1},className:"button red",onClick:P=>{P.stopPropagation(),g.PopUp.set({title:n("APPS.CRYPTO.SELL_ALL_POPUP.TITLE").format({coin:e.symbol}),description:n("APPS.CRYPTO.SELL_ALL_POPUP.DESCRIPTION").format({coin:e.symbol,amount:e.owned*e.current_price}),buttons:[{title:n("APPS.CRYPTO.SELL_ALL_POPUP.CANCEL")},{title:n("APPS.CRYPTO.SELL_ALL_POPUP.PROCEED"),color:"red",cb:()=>{let s=e.owned*e.current_price;c(e.id,s,e.owned)}}]})},children:n("APPS.CRYPTO.SELL_ALL")})]})})]})},F=e=>{if(!(e!=null&&e.data.prices))return null;let t=e.data.prices;const d=r.useRef(null),[h,p]=r.useState(null),[T,O]=r.useState(null);return t=t.slice(0,24),r.useEffect(()=>{if(!(d!=null&&d.current))return;const i=d.current;i.width=150,i.height=100;const c=i.getContext("2d");c.lineWidth=3;const P=Math.min(...t),l=Math.max(...t)-P,u=i.height-10;let m=0,a=i.height-5-(t[0]-P)/l*u;c.beginPath(),c.moveTo(m,a);const v=t[t.length-1]-t[0]>0?"green":"red";c.strokeStyle=v;for(let R=1;R<t.length;R++)m+=i.width/(t.length-1),a=i.height-5-(t[R]-P)/l*u,c.lineTo(m,a);c.stroke();const E=(t[t.length-1]-t[0])/t[0]*100;E>0?p(`<div style="color: var(--phone-color-green)">+${S(E,2)}%</div>`):E<0?p(`<div style="color: var(--phone-color-red)">${S(E,2)}%</div>`):p(`<div>${S(E,2)}%</div>`);let f=(e.data.value-e.data.invested)/e.data.invested*100;f>0?O(`<div style="color: var(--phone-color-green)">+${S(f,2)}%</div>`):f<0&&O(`<div style="color: var(--phone-color-red)">${S(f,2)}%</div>`)},[d,t]),o($,{text:`$${S(e.data.current_price,2)} ${h??""} ${T??""}`,children:o("canvas",{ref:d})})};export{z as default};
