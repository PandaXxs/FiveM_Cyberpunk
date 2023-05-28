import{r as l,a as i,j as t}from"./jsx-runtime-7cf68bf7.js";import{u as L,f as r,H as F,q as $,L as a,ah as v,Z as j,C as E,$ as q,U as M,o as O,a6 as V,Y as H,b as f,N as K}from"./Phone-ec5c0d3e.js";function z(){const C=L(f.Settings),g=L(f.PhoneNumber),Y=L(K),[T,b]=l.useState(!1),[c,o]=l.useState([]),[p,m]=l.useState(!1),[s,P]=l.useState(null),[w,R]=l.useState(0),[G,S]=l.useState(!1),[I,N]=l.useState(!1),[h,W]=l.useState(""),[A,y]=l.useState(""),[U,k]=l.useState([]);l.useEffect(()=>{const e=setTimeout(()=>W(A),500);return()=>clearTimeout(e)},[A]),l.useEffect(()=>{h.length>0&&r("YellowPages",{action:"search",query:h}).then(e=>{e&&k(e)})},[h]),l.useEffect(()=>{r("YellowPages",{action:"getPosts",page:0}).then(e=>{e&&e.length>0?(o(e),e.length<10&&S(!0)):S(!0)}),r("isAdmin").then(e=>b(e))},[]);const D=()=>{if(!(s!=null&&s.title)||!(s!=null&&s.description)){let n;switch(!0){case!(s!=null&&s.title):n=a("APPS.YELLOWPAGES.ERROR_POPUP.NO_TITLE");break;case!(s!=null&&s.description):n=a("APPS.YELLOWPAGES.ERROR_POPUP.NO_DESCRIPTION");break}E.PopUp.set({title:a("APPS.YELLOWPAGES.ERROR_POPUP.TITLE"),description:n,buttons:[{title:a("APPS.YELLOWPAGES.ERROR_POPUP.OK")}]});return}let e={...s,number:g};r("YellowPages",{action:"sendPost",data:e}).then(n=>{n&&(o([{...e,id:n},...c]),m(!1))})},_=e=>{e&&E.PopUp.set({title:a("APPS.YELLOWPAGES.DELETE_POPUP.TITLE"),description:a("APPS.YELLOWPAGES.DELETE_POPUP.TEXT"),buttons:[{title:a("APPS.YELLOWPAGES.DELETE_POPUP.CANCEL")},{title:a("APPS.YELLOWPAGES.DELETE_POPUP.PROCEED"),color:"red",cb:()=>{r("YellowPages",{action:"deletePost",id:e}).then(n=>{n&&o(c.filter(u=>u.id!==e))})}}]})},x=e=>{if(G||I)return;let n=document.querySelector("#last");if(!n)return;!H(n)&&(N(!0),r("YellowPages",{action:"getPosts",page:w+1}).then(d=>{d&&d.length>0?(o([...c,...d]),N(!1)):S(!0)}),R(d=>d+1))};return F("yellowPages:newPost",e=>{C.airplaneMode||o([e,...c])}),l.useEffect(()=>{P(null)},[p]),i("div",{className:"pages-container",children:[t("div",{className:"pages-header",children:t($,{theme:"light",placeholder:a("APPS.YELLOWPAGES.SEARCH"),onChange:e=>y(e.target.value)})}),t("div",{className:"add",onClick:()=>m(!0),children:t(v,{})}),t("div",{className:"pages-wrapper",children:t("div",{className:"posts",onScroll:x,children:(h.length>0?U:c).map((e,n)=>{let u=n===c.length-1?"last":"";return i("div",{className:"post",id:u,children:[i("div",{className:"post-header",children:[a("APPS.YELLOWPAGES.FROM")," ",j(e.number)]}),i("div",{className:"post-content",children:[i("div",{className:"info",children:[t("div",{className:"title",children:e.title}),t("div",{className:"description",children:e.description})]}),e.attachment&&t("div",{className:"image",onClick:()=>{E.FullscreenImage.set({display:!0,image:e.attachment})},children:t(q,{src:e.attachment})})]}),i("div",{className:"post-footer",children:[e.price?t("div",{className:"price",children:Y.CurrencyFormat.replace("%s",e.price)}):t("div",{}),i("div",{className:"buttons",children:[t("div",{className:"button",onClick:()=>{window.postMessage({data:{number:e.number,popUp:!0},action:"phone:contact"})},children:a("APPS.YELLOWPAGES.CALL")}),(g===e.number||T)&&t("div",{className:"button red",onClick:()=>_(e.id),children:t(M,{})})]})]})]},n)})})}),p&&i("div",{className:"new-post-container",children:[i("div",{className:"new-post-header",children:[t("div",{className:"cancel",onClick:()=>m(!1),children:a("APPS.YELLOWPAGES.CANCEL")}),t("div",{className:"title",children:a("APPS.YELLOWPAGES.NEW_POST")}),t("div",{})]}),i("div",{className:"new-post-body",children:[i("div",{className:"item",children:[t("div",{className:"title",children:a("APPS.YELLOWPAGES.TITLE")}),t(O,{type:"text",placeholder:a("APPS.YELLOWPAGES.TITLE"),maxLength:50,onChange:e=>P({...s,title:e.target.value})})]}),i("div",{className:"item",children:[t("div",{className:"title",children:a("APPS.YELLOWPAGES.DESCRIPTION")}),t(V,{type:"text",placeholder:a("APPS.YELLOWPAGES.DESCRIPTION"),maxLength:250,rows:5,onChange:e=>P({...s,description:e.target.value})})]}),t("div",{className:"item",children:t("div",{className:"image",style:{backgroundImage:`url(${s==null?void 0:s.attachment})`},onClick:()=>{E.Gallery.set({onSelect:e=>P({...s,attachment:e.src})})},children:t(v,{})})}),i("div",{className:"item",children:[t("div",{className:"title",children:a("APPS.YELLOWPAGES.PRICE")}),t(O,{type:"number",placeholder:"0",onChange:e=>{if(!e.target.value.match(/^[0-9]*$/))return e.preventDefault();P({...s,price:!isNaN(parseFloat(e.target.value))&&parseFloat(e.target.value)})}})]}),t("div",{className:"button",onClick:()=>D(),children:a("APPS.YELLOWPAGES.POST")})]})]})]})}export{z as default};