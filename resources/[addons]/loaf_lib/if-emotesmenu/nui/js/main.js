$(function() {
    let config = {};
    let emotesData = {};
    let sortMethod = 0; // 0: alphabetically, 1: often used.
    let emotesUseFrequency = {};

    window.addEventListener('message', function(e) {
        const data = e.data;

        if (data.type == 'loadData' && data.emotesData) {
            config = data.config;
            emotesData = data.emotesData;
            loadEmotesList()
        } else if (data.type == 'open') {
            $('body').show()
        } else if (data.type == 'updateData') {
            if (data.updatePart == 'emotesData') {
                Object.entries(data.updatedData).forEach(([emotePart, emoteData]) => {
                    if (emotesData[emotePart] && emotesData[emotePart] == emoteData) return;
                    emotesData[emotePart] = emoteData;
                    updateEmoteList(emotePart)
                })
            } else if (data.updatePart == 'emojiFrequencyList') {
                emotesUseFrequency = data.updatedData;
            }
        }
    });

    window.addEventListener('keydown', function({ code }) {
        if (code === "Escape") {
            $.post('https://if-emotesmenu/close');
            $('body').hide();
            $('.keybinsDialog').css('display', 'none');
            $('.keybinsDialog button').off('click');
            $('.keybinsDialog #closeBtn').off('click');
        }
    });

    function buttonFuncs(e) {
        const buttonId = $(this).attr('id');
        const partId = $(this).parents('div').parents('div').attr('data-partId');
        const emoteId = $(this).parents('div').parents('div').attr('data-emoteId');

        if (buttonId == 'addBind' || buttonId == 'removeBind' || buttonId == 'changeBind') {
            $.post('https://if-emotesmenu/handleBind', JSON.stringify({
                type: buttonId.replace('Bind',''),
                emote: {
                    category: partId,
                    name: emoteId
                }
            }), function(data) {
                if (data) {
                    if (data.response == 'openBindDialog') {
                        $('.keybinsDialog').css('display', 'flex');
                        for (let i = 1; i <= 7; i++) {
                            if (data.availableBinds[String(i)]) {
                                $(`#keybindBtn${i}`).prop("disabled", false);
                            } else {
                                $(`#keybindBtn${i}`).prop("disabled", true);
                            }
                        }
                        $('.keybinsDialog button').click(function(e) {
                            const bind = (e.currentTarget.id).replace('keybindBtn', '');

                            $.post('https://if-emotesmenu/handleBind', JSON.stringify({
                                type: 'set',
                                oldKeybind: buttonId == 'change' ?? data.currentBind,
                                selectedKeybind: bind,
                                emote: {
                                    category: partId,
                                    name: emoteId
                                }
                            }));

                            $('.keybinsDialog').css('display', 'none');
                            $('.keybinsDialog button').off('click');
                            $('.keybinsDialog #closeBtn').off('click');
                        });
                        $('.keybinsDialog #closeBtn').click(function() {
                            $('.keybinsDialog').css('display', 'none');
                            $('.keybinsDialog button').off('click');
                            $('.keybinsDialog #closeBtn').off('click');
                        });
                    }
                }
            })
        } else if (buttonId == 'play') {
            $.post('https://if-emotesmenu/playEmote', JSON.stringify({partId, emoteId}));
            if (config.PlayClosesTheUI) $('body').hide()
        } else if (buttonId == 'favorite' || buttonId == 'unfavorite') {
            $.post('https://if-emotesmenu/handleFavEmote', JSON.stringify({
                type: buttonId,
                emote: {
                    category: buttonId == 'favorite' && partId || buttonId == 'unfavorite' && $(this).parents('div').parents('div').attr('data-emoteCategory'),
                    name: emoteId,
                }
            }))
        };
    };

    function loadEmotesList() {
        Object.entries(emotesData).forEach(([emotePart, emoteData]) => {
            const partId = emotePart == 'dance' && 'm1' || 
            emotePart == 'special' && 'm2' || 
            emotePart ==  'walkstyle' && 'm3' ||
            emotePart ==  'communication' && 'm4' ||
            emotePart ==  'emotions' && 'm5' ||
            emotePart ==  'favorites' && 'm6' ||
            emotePart ==  'nsfw' && 'm7';

            const emoteImage = emotePart == 'dance' && 'e1' || 
            emotePart == 'special' && 'star' || 
            emotePart ==  'walkstyle' && 'e3' ||
            emotePart ==  'communication' && 'e4' ||
            emotePart ==  'emotions' && 'e5' ||
            emotePart ==  'favorites' && 'e6' ||
            emotePart ==  'nsfw' && 'e6';
            
            if (!emoteData || typeof emoteData != 'object') {
                $(`a[href$="#${partId}"]`).hide();
                return
            };

            if (emotePart == 'communication' || emotePart == 'dance' || emotePart == 'special' || emotePart == 'emotions') {
                const sorted = Object.entries(emoteData).sort((a, b) => {
                    if (a?.[1]?.[3] && b?.[1]?.[3] && emotePart != 'emotions') {
                        return a[1][3].localeCompare(b[1][3])

                    } else if (a?.[1]?.[1] && b?.[1]?.[1] && emotePart != 'emotions') {
                        return a[1][1].localeCompare(b[1][1])

                    } else if (a?.[1]?.[0] && b?.[1]?.[0]) {
                        return a[1][0].localeCompare(b[1][0])
                    }
                    return false
                });
                if (sorted) emoteData = Object.fromEntries(sorted)
            } else {
                const sorted = Object.keys(emoteData).sort().reduce(
                    (obj, key) => { 
                        obj[key] = emoteData[key]; 
                        return obj;
                    }, 
                    {}
                );
                if (sorted) emoteData = sorted;
            };

            if (emotePart !== 'favorites') {
                Object.entries(emoteData).forEach(([emoteId, emote]) => {
                    let emoteLabel = emote[3] ?? emote[1] ?? emoteId;
                    if (emotePart == 'emotions') emoteLabel = emote[0];
                    const emojiSingleTab = `
                        <div class="emoji__tab" data-partId="${emotePart}" data-emoteId="${emoteId}">
                            <div class="emoji__tab-icon">
                                <img src="assets/images/${emoteImage}.png" alt="emoji" />
                                <img src="assets/images/${emoteImage}-hover.png" alt="img">
                            </div>
                            <div class="emoji__tab-content">
                            <div class="emoji__tab-text">
                                <h3>${emoteLabel}</h3>
                                <p>/e ${emoteId}</p>
                            </div>
                            <ul class="emoji__tab-btns">
                                <li>
                                    <button id="addBind">
                                        <i class="fa-solid fa-circle-plus"></i>
                                        <span>Add Bind</span>
                                    </button>
                                </li>
                                <li>
                                    <button id="play">
                                        <i class="fa-sharp fa-solid fa-circle-play"></i>
                                        <span>Play</span>
                                    </button>
                                </li>
                                <li>
                                    <button id="favorite">
                                        <i class="fa-solid fa-heart"></i>
                                        <span>Favorite</span>
                                    </button>
                                </li>
                            </ul>
                            </div>
                        </div>
                    `;
    
                    $(`#${partId} #emojisMainContent`).append(emojiSingleTab)
                })
    
            } else if (emotePart == 'favorites') {
                Object.entries(emoteData).forEach(([key, emote]) => {
                    emote.label = emotesData[emote.category][emote.name]?.[3] ?? emotesData[emote.category][emote.name]?.[1] ?? emote.name
                    const emojiSingleTab = `
                        <div class="emoji__tab" data-partId="${emotePart}" data-emoteCategory="${emote.category}" data-emoteId="${emote.name}">
                            <div class="emoji__tab-icon">
                                <img src="assets/images/${emoteImage}.png" alt="emoji" />
                                <img src="assets/images/${emoteImage}-hover.png" alt="img">
                            </div>
                            <div class="emoji__tab-content">
                            <div class="emoji__tab-text">
                                <h3>${emote.label}</h3>
                                <p>/e ${emote.name}</p>
                            </div>
                            <ul class="emoji__tab-btns">
                                <li>
                                    <button id="addBind">
                                        <i class="fa-solid fa-circle-plus"></i>
                                        <span>Add Bind</span>
                                    </button>
                                </li>
                                <li>
                                    <button id="play">
                                        <i class="fa-sharp fa-solid fa-circle-play"></i>
                                        <span>Play</span>
                                    </button>
                                </li>
                                <li>
                                    <button id="unfavorite">
                                        <i class="fa-solid fa-heart-crack"></i>
                                        <span>Unfavorite</span>
                                    </button>
                                </li>
                            </ul>
                            </div>
                        </div>
                    `;
                    $(`#${partId} #emojisMainContent`).append(emojiSingleTab)
                })
            };

            $(`#${partId} .search input`).on('keyup', function() {
                const value = $(this).val().toLowerCase();
                $(`#${partId} #emojisMainContent`).filter(function() {
                    const emotes = $(this).children('.emoji__tab');
                    emotes.each(function() {
                        $(this).toggle($(this).find('h3').text().toLowerCase().indexOf(value) > -1)
                    })
                })
            })
        });

        if (emotesData['keybinds']) {
            for (let i = 1; i <= 7; i++) {
                $(`#m${i} #bindedEmotes`).empty()
            };
            Object.entries(emotesData['keybinds']).forEach(([keybind, emote]) => {
                const emoteCategoryImage = emote.category == 'dance' && 'e1' || 
                emote.category == 'special' && 'star' || 
                emote.category ==  'walkstyle' && 'e3' ||
                emote.category ==  'communication' && 'e4' ||
                emote.category ==  'emotions' && 'e5' ||
                emote.category ==  'favorites' && 'e6';
                emote.label = emotesData[emote.category][emote.name]?.[3] ?? emotesData[emote.category][emote.name]?.[1] ?? emote.name
                const emojiSingleTab = `
                    <div class="emoji__tab" data-keybind="${keybind}" data-partId="${emote.category}" data-emoteId="${emote.name}">
                        <div class="emoji__tab-icon">
                            <img src="assets/images/${emoteCategoryImage}.png" alt="emoji" />
                            <img src="assets/images/${emoteCategoryImage}-hover.png" alt="img">
                        </div>
                        <div class="emoji__tab-content">
                            <div class="emoji__tab-text">
                                <h3>${keybind} - ${emote.label}</h3>
                                <p>/e ${emote.name}</p>
                            </div>
                            <ul class="emoji__tab-btns">
                                <li>
                                    <button id="changeBind">
                                        <i class="fa-solid fa-f"></i>
                                        <span>Change Bind</span>
                                    </button>
                                </li>
                                <li>
                                    <button id="removeBind">
                                        <i class="fa-solid fa-circle-minus"></i>
                                        <span>Remove Bind</span>
                                    </button>
                                </li>
                                <li>
                                    <button id="play">
                                        <i class="fa-sharp fa-solid fa-circle-play"></i>
                                        <span>Play</span>
                                    </button>
                                </li>
                            </ul>
                        </div>
                    </div>
                `;
                for (let i = 1; i <= 7; i++) {
                    $(`#m${i} #bindedEmotes`).append(emojiSingleTab)
                }
            })
        };

        $('.emoji__tab-btns button').click(buttonFuncs)
    };

    function updateEmoteList(emotePart) {
        if (emotePart == 'keybinds') {
            for (let i = 1; i <= 7; i++) {
                $(`#m${i} #bindedEmotes`).empty()
            };
            Object.entries(emotesData['keybinds']).forEach(([keybind, emote]) => {
                const emoteCategoryImage = emote.category == 'dance' && 'e1' || 
                emote.category == 'special' && 'star' || 
                emote.category ==  'walkstyle' && 'e3' ||
                emote.category ==  'communication' && 'e4' ||
                emote.category ==  'emotions' && 'e5' ||
                emote.category ==  'favorites' && 'e6';
                emote.label = emotesData[emote.category][emote.name]?.[3] ?? emotesData[emote.category][emote.name]?.[1] ?? emote.name
                const emojiSingleTab = `
                    <div class="emoji__tab" data-keybind="${keybind}" data-partId="${emote.category}" data-emoteId="${emote.name}">
                        <div class="emoji__tab-icon">
                            <img src="assets/images/${emoteCategoryImage}.png" alt="emoji" />
                            <img src="assets/images/${emoteCategoryImage}-hover.png" alt="img">
                        </div>
                        <div class="emoji__tab-content">
                            <div class="emoji__tab-text">
                                <h3>${keybind} - ${emote.label}</h3>
                                <p>/e ${emote.name}</p>
                            </div>
                            <ul class="emoji__tab-btns">
                                <li>
                                    <button id="changeBind">
                                        <i class="fa-solid fa-f"></i>
                                        <span>Change Bind</span>
                                    </button>
                                </li>
                                <li>
                                    <button id="removeBind">
                                        <i class="fa-solid fa-circle-minus"></i>
                                        <span>Remove Bind</span>
                                    </button>
                                </li>
                                <li>
                                    <button id="play">
                                        <i class="fa-sharp fa-solid fa-circle-play"></i>
                                        <span>Play</span>
                                    </button>
                                </li>
                            </ul>
                        </div>
                    </div>
                `;
                for (let i = 1; i <= 7; i++) {
                    $(`#m${i} #bindedEmotes`).append(emojiSingleTab)
                }
            })
        } else if (emotePart == 'favorites') {
            $('#m6 #emojisMainContent').empty();
            Object.entries(emotesData['favorites']).forEach(([key, emote]) => {
                emote.label = emotesData[emote.category][emote.name]?.[3] ?? emotesData[emote.category][emote.name]?.[1] ?? emote.name
                const emojiSingleTab = `
                    <div class="emoji__tab" data-partId="${emotePart}" data-emoteCategory="${emote.category}" data-emoteId="${emote.name}">
                        <div class="emoji__tab-icon">
                            <img src="assets/images/e6.png" alt="emoji" />
                            <img src="assets/images/e6-hover.png" alt="img">
                        </div>
                        <div class="emoji__tab-content">
                        <div class="emoji__tab-text">
                            <h3>${emote.label}</h3>
                            <p>/e ${emote.name}</p>
                        </div>
                        <ul class="emoji__tab-btns">
                            <li>
                                <button id="addBind">
                                    <i class="fa-solid fa-circle-plus"></i>
                                    <span>Add Bind</span>
                                </button>
                            </li>
                            <li>
                                <button id="play">
                                    <i class="fa-sharp fa-solid fa-circle-play"></i>
                                    <span>Play</span>
                                </button>
                            </li>
                            <li>
                                <button id="unfavorite">
                                    <i class="fa-solid fa-heart-crack"></i>
                                    <span>Unfavorite</span>
                                </button>
                            </li>
                        </ul>
                        </div>
                    </div>
                `;
                $('#m6 #emojisMainContent').append(emojiSingleTab)
            })
        };
        $('.emoji__tab-btns button').off();
        $('.emoji__tab-btns button').click(buttonFuncs)
    };



    // DEV | PROD ENV SETTER
    if (GetParentResourceName()) {
        $('body').hide();
        $.post(`https://${GetParentResourceName()}/nuiReady`, '{}')
    }
})