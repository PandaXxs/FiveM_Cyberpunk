import{r as a,a as l,j as n,F as O}from"./jsx-runtime-7cf68bf7.js";import{u as H,h,f as C,L as r,ah as F,C as K,bz as j,K as q,M as W,b as w,H as X,bx as $,bA as z,Z as B,a0 as y,o as J,by as Y,Y as Z}from"./Phone-ec5c0d3e.js";function G(){const{Username:f,View:m,Channel:D}=a.useContext(k),[R,o]=D,[v,P]=m,[S]=f,[T,u]=a.useState(""),d=H(w.Settings),A=H(h.APPS.DARKCHAT.channels);return a.useEffect(()=>{h.APPS.DARKCHAT.channels.value||C("DarkChat",{action:"getChannels"}).then(t=>{t&&h.APPS.DARKCHAT.channels.set(t)})},[]),l("div",{className:"animation-slide right",children:[l("div",{className:"darkchat-header",children:[n("div",{className:"title",children:r("APPS.DARKCHAT.TITLE")}),n(F,{onClick:()=>{S&&K.PopUp.set({title:r("APPS.DARKCHAT.NEW_ROOM"),description:r("APPS.DARKCHAT.NEW_ROOM_TEXT"),input:{placeholder:r("APPS.DARKCHAT.ROOM_CODE"),type:"password",minCharacters:3,onChange:t=>u(t)},buttons:[{title:r("APPS.DARKCHAT.CANCEL")},{title:r("APPS.DARKCHAT.JOIN"),cb:()=>{u(t=>(C("DarkChat",{action:"joinChannel",name:t}).then(s=>{s&&(o({name:t}),P("chat"),h.APPS.DARKCHAT.channels.set([s,...A]))}),t))}}]})}})]}),n("div",{className:"channels-body",children:A==null?void 0:A.map((t,s)=>l("div",{className:"channel",onClick:()=>{S&&(o(t),P("chat"))},children:[l("div",{className:"channel-info",children:[l("div",{className:"channel-name",children:["#",d.streamerMode?"*****":t.name]}),l("div",{className:"recent-message",children:[l("div",{className:"members",children:[n(j,{}),l("span",{children:[t.members,":"]})]}),t.lastMessage]})]}),l("div",{className:"right",children:[n("div",{className:"timestamp",children:q(t.timestamp)}),n(W,{})]})]},s))})]})}function Q(){const{Username:f,View:m,Channel:D}=a.useContext(k),R=H(w.Settings),[o,v]=D,[P]=f,[S,T]=m,u=a.useRef(null),[d,A]=a.useState(""),[t,s]=a.useState([]),[g,V]=a.useState(0),[L,E]=a.useState(!1),[_,M]=a.useState(!1);a.useEffect(()=>{C("DarkChat",{action:"getMessages",page:0,channel:o.name}).then(e=>{e&&e.length>0?(s(e.reverse()),e.length<15&&E(!0)):E(!0)})},[]);const x=e=>{if(L||_)return;let c=document.querySelector("#last");if(!c)return;!Z(c)&&(M(!0),C("DarkChat",{action:"getMessages",page:g+1,channel:o.name}).then(p=>{p&&p.length>0?(s([...p.reverse(),...t]),M(!1)):E(!0)}),V(p=>p+1))};a.useEffect(()=>{let e=document.querySelector(".chat-wrapper");e.scrollTop=e.scrollHeight},[t]);const b=()=>{if(d.length>0){let e={sender:P,content:d,timestamp:new Date().getTime()};C("DarkChat",{action:"sendMessage",content:d,channel:o.name}).then(()=>{A(""),u.current.value="",s([...t,e]);let c=h.APPS.DARKCHAT.channels.value.map(i=>(i.name===o.name&&(i.lastMessage=e.content,i.timestamp=new Date),i));h.APPS.DARKCHAT.channels.set(c)})}};return X("darkChat:newMessage",e=>{if(o.name!==e.channel)return;let c=h.APPS.DARKCHAT.channels.value.map(i=>(i.name===e.channel&&(i.lastMessage=e.content,i.timestamp=new Date),i));h.APPS.DARKCHAT.channels.set(c),s([...t,{...e,timestamp:new Date().getTime()}])}),l("div",{className:"animation-slide left",children:[l("div",{className:"darkchat-header chat",children:[n($,{onClick:()=>{T("channels"),v(null)}}),l("div",{className:"title",children:["#",R.streamerMode?"*****":o.name]}),n(z,{onClick:()=>{K.PopUp.set({title:r("APPS.DARKCHAT.LEAVE_ROOM"),description:r("APPS.DARKCHAT.LEAVE_ROOM_TEXT"),buttons:[{title:r("APPS.DARKCHAT.CANCEL")},{title:r("APPS.DARKCHAT.LEAVE"),color:"red",cb:()=>{C("DarkChat",{action:"leaveChannel",channel:o.name}).then(e=>{if(e){T("channels"),v(null);let c=h.APPS.DARKCHAT.channels.value.filter(i=>i.name!==o.name);h.APPS.DARKCHAT.channels.set(c)}})}}]})}})]}),n("div",{className:"chat-wrapper",onScroll:x,children:n("div",{className:"chat-body",children:t.map((e,c)=>{var I;let i,p=c===0?"last":"",N=e.sender===P?"self":"other",U=((I=t[c+1])==null?void 0:I.sender)===P?"self":"other";return t[c+1]?i=Math.abs(e.timestamp-t[c+1].timestamp)/36e5:U=void 0,l("div",{className:`message ${N}`,id:p,children:[N=="other"&&n("div",{className:"user",children:e.sender}),n("div",{className:"content",children:B(e.content)}),t[c+1]&&i>6?n("div",{className:"date",children:y(e.timestamp)}):N!==U&&n("div",{className:"date",children:y(e.timestamp)})]},c)})})}),l("div",{className:"chat-bottom",children:[n(J,{type:"text",placeholder:r("APPS.DARKCHAT.INPUT_PLACEHOLDER"),value:d,ref:u,onChange:e=>{A(e.target.value)},onKeyDown:e=>{if(e.key==="Enter")return b()}}),n(Y,{onClick:()=>b()})]})]})}const k=a.createContext(null);function ne(){const[f,m]=a.useState(null),[D,R]=a.useState(null),[o,v]=a.useState("channels"),[P,S]=a.useState(""),[T,u]=a.useState(!1),[d,A]=a.useState(!0);a.useEffect(()=>{if(h.APPS.DARKCHAT.username.value){m(h.APPS.DARKCHAT.username.value),A(!1);return}C("DarkChat",{action:"getUsername"}).then(s=>{A(!1),s&&(m(s),h.APPS.DARKCHAT.username.set(s))})},[]);const t={channels:n(G,{}),chat:n(Q,{})};return n("div",{className:"darkchat-container",children:n(k.Provider,{value:{Username:[f,m],View:[o,v],Channel:[D,R]},children:!d&&l(O,{children:[!f&&!T&&l(O,{children:[u(!0),K.PopUp.set({title:r("APPS.DARKCHAT.USERNAME"),description:r("APPS.DARKCHAT.SET_USERNAME"),input:{placeholder:r("APPS.DARKCHAT.USERNAME"),type:"text",minCharacters:3,onChange:s=>S(s)},buttons:[{title:r("APPS.DARKCHAT.CANCEL"),cb:()=>w.App.reset()},{title:r("APPS.DARKCHAT.SET"),cb:()=>{S(s=>(C("DarkChat",{action:"setUsername",username:s}).then(g=>{if(!g)return u(!1);m(s)}),s))}}]})]}),t[o]]})})})}export{k as DarkChatContext,ne as default};