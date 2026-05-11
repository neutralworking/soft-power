"""
Build a book-format typeset sample of Soft Power.

Renders three scenes (Elleh Toledoh, Mind Rain, The Masque of Anarchy) plus
the front matter as a single A5 PDF, so an editor or agent can see what the
manuscript would look like on the page in book form.

Run:  python3 build_sample.py
Out:  soft_power_sample.pdf
"""

from weasyprint import HTML, CSS
from pathlib import Path

OUT_DIR = Path(__file__).parent
PDF_PATH = OUT_DIR / "soft_power_sample.pdf"


# ---------------------------------------------------------------------------
# Content. Each scene is a list of blocks. A block is one of:
#   ("setting", "italic scene-setting prose")
#   ("stage",   "italic stage direction prose")
#   ("speaker", "Name")              -> small-caps speaker label
#   ("stanza",  ["line", "line", ...])
#   ("prose",   "paragraph of prose")
# ---------------------------------------------------------------------------

EPIGRAPH = [
    "But most of us turn slow to see",
    "The figure hanging on a tree",
    "And stumble on and blindly grope",
    "Upheld by intermittent hope,",
    "God grant before we die we all",
    "May see the light as did St. Paul.",
]
EPIGRAPH_CREDIT = "— John Betjeman, “The Conversion of St. Paul”"


SCENE_1 = {
    "act": "Act One",
    "act_subtitle": "Maundy Thursday",
    "number": "1",
    "title": "Elleh Toledoh",
    "setting": "Sunset Club, Camden. Cosmo’s wake.",
    "blocks": [
        ("stanza", [
            "The only soul made brave enough to tell the tale,",
            "You can call me the designated Raphael.",
            "Follow close past sickened hearts out the bitter cold",
            "To a yet unknowing subterranean world.",
        ]),
        ("stanza", [
            "Iced boots and coats defrosted in a hot Sunset,",
            "A hole on Chalk Farm Road built in an old bunker,",
            "Acrid mist rising from the blackened wood, beading",
            "In fat pear-shaped tears resting on the low ceiling.",
        ]),
        ("stanza", [
            "Some eyes here he’d met before, some were only types.",
            "By the fire exit, stilettos too high for a wake.",
            "The garden overflow’th with fruit now overripe,",
            "Softening with bitterness, like this rotten state",
            "Of mind demarcated around the prince’s crown.",
            "Appalled but drawn to parricidal decisions,",
            "Caught in static semantic disposition,",
        ]),
        ("stage", "A spotlight finds Joly."),
        ("stanza", [
            "Here Joly stands, too scared-stiff to face the jury,",
            "Clutching empty bottles from a bought-out brewery.",
            "Thus a crossroads, halfway along Joly’s life’s path.",
            "A crooked lane through the dark wood, fumbling through farce.",
            "He’d finished his shy Tokaji far from prying eyes,",
            "But now with his glass empty and dry, it was time.",
        ]),
        ("stage", "Joly stumbles to the bar, resting a hand on a table for stability on the way."),
        ("stanza", [
            "Stable hand on the table, said to be favoured",
            "By Eliot in the 20s, later a blaze",
            "During a Clash gig razed the whole place to the bones,",
            "Along with some unfortunate souls some allege",
            "Never left, haunting the club’s dancefloor like disco.",
        ]),
        ("stanza", [
            "The brothers came at Cosmo’s request, Joly’s grimace.",
            "The spirits mixed with the spirits to raise spirits,",
        ]),
        ("stage", "Joly receives his drink from the bar."),
        ("stanza", [
            "The likes of which The Dilettantes, their indie band,",
            "Had never seen, green in the underground mystique,",
            "Always rehearsing lines they’d never get to say,",
            "Now with war stories, they could finally come to play.",
        ]),
        ("stanza", [
            "Cosmo alone had craved the fame, reclaimed",
            "His art and learned to disdain the family name.",
            "While Joly, knowing his place in the music space,",
            "Kept his collar tight, his playlist even tighter.",
            "He had fallen out of love and grace with Delphine,",
        ]),
        ("stage", "A spotlight finds Delphine."),
        ("stanza", [
            "Five years prior a singer in a 2B band,",
            "But now a face on every bus on Chalk Farm Road.",
            "She lived in the Camden Square flat with their daughter,",
            "He’d drifted so far out to Bermudan waters,",
            "Six weeks since he’d changed her nappy — did she still wear them?",
            "He wasn’t even meant to be out late tonight.",
        ]),
        ("stage", "The spotlight shifts to the dancefloor."),
        ("stanza", [
            "Now he shares a dark dance-floor with nocturnal sprites,",
            "Molochs and angel-headed hipsters, street disciples",
            "Of a culture found young and lost, loved and reviled.",
            "It’s twelve years since Cos brought him here for the first time,",
            "Saying he’d met some of the generation’s best minds",
            "Destroyed by madness and absurdity, burdened",
            "By purposelessness, beholden to urgency,",
            "Too weak to complete their journey, instead twisting",
            "Listlessly through miserable purgatory, fists",
            "Vainly raised towards the Leviathan, lyres",
            "Strumming melodies aimed at powers dark and light,",
            "Pleasing to a greensleeved producer such as him,",
            "Settling at 2B Records, under his father’s wing.",
        ]),
        ("stanza", [
            "Keen to please the patriarch, he resolved to sign",
            "Most talented malcontents, how woe betided!",
            "A mistake he’d never make again, so he thought,",
            "Until Cosmo’s ship never made it into port.",
            "They buried his empty grave this April morning",
            "After 2 weeks in the Port of Spezia trawling.",
            "The brothers were never close, six years between them,",
            "Their fraternal love a labour Sisyphean",
            "Before Cos hit the road like Henry. He wrote",
            "Joly a parting poem, the least he was owed.",
        ]),
        ("stage", "Joly takes out the letter."),
        ("speaker", "Cosmo (unseen)"),
        ("stanza", [
            "I’ve left because I wish to live deliberately,",
            "To front on only the essential facts of life,",
            "And see if I could not learn only what is taught,",
            "But realise in death’s when I truly come alive.",
            "Sprung free from our jobs, cars, offices, and taxes,",
            "Here in the woods, me and Waldo are relaxing.",
            "We don’t work with our hands, we don’t walk with our feet,",
            "Insist upon yourself brother, insist and be free.",
        ]),
        ("narrator_resume",),
        ("stanza", [
            "Joly read the letter while waiting for a slash,",
            "Behind lads on the lash relying on white lines",
            "To smash with punchlines rehashed from Turkish tombstone",
            "Teeth smiles flashed at some unimpressed gash in the line.",
        ]),
        ("stanza", [
            "A tear wells, like Orson. Prismed, he viewed a friend,",
            "Tom Windsor, waving like no tomorrow.",
            "Funny hat, shiny pants, half an ounce in his hands,",
            "Beckoned to the front of the queue, Joly followed.",
        ]),
        ("speaker", "Tom"),
        ("stanza", [
            "You were looking lost out there, old chum. In we go,",
            "There’s a good boy. I know you don’t partake per se,",
            "But Cosmo and I were Colombian brothers,",
            "So I feel it’s only fair in his honour, eh?",
        ]),
        ("stage", "Joly and Tom do lines."),
        ("stanza", [
            "We shared a charlie plug — Dante, you knew him —",
            "In fact, I thought that the whole event was “catered”",
            "Because somebody bought him clean out last weekend,",
            "I almost made the mistake of not bringing any.",
        ]),
        ("stage", "An angry bouncer knocks on the door."),
        ("speaker", "Tom"),
        ("prose", "We’re having sex, fuck off. Are you finishing that?"),
    ],
}


SCENE_2 = {
    "number": "2",
    "title": "Mind Rain",
    "setting": "Eurostar Standard Premium carriage.",
    "blocks": [
        ("stage", "Norah Healy lounges in her seat with her naked feet on the seat in front of hers, messily eating a sausage roll. The man in the seat next to her is an unwilling participant in their conversation."),
        ("speaker", "Norah"),
        ("prose", "They should really extend the Eurostar worldwide. It’s the best way to travel."),
        ("narrator_resume",),
        ("stage", "She could tell this guy really wanted to read his free copy of the Economist."),
        ("speaker", "Norah"),
        ("prose", "Have you taken your girlfriend to Paris before?"),
        ("narrator_resume",),
        ("stage", "She already knew he didn’t have a girlfriend, having found him on Facebook from the name on his ticket within 30 seconds of him sitting down."),
        ("speaker", "Chump"),
        ("prose", "It wouldn’t work anyway, your plan. It’s called the Eurostar, it would be confusing for people if it went all over the world."),
        ("speaker", "Norah"),
        ("prose", "The Northern line goes to South London dipshit, do people get confused by that?"),
        ("narrator_resume",),
        ("stanza", [
            "In the violet hour",
            "60 feet under la Manche",
            "She could almost taste Dover.",
        ]),
        ("stanza", [
            "Hyacinths and a sausage roll",
            "From Gare de Nord",
            "chug chug chug",
        ]),
        ("stanza", [
            "Norah Healy was in good spirits",
            "Complimentary in Standard Premium",
            "Girls across the aisle dance the Nasturtium",
        ]),
        ("speaker", "Girls"),
        ("stanza", [
            "Dansons la capucine,",
            "Y’a pas de pain chez nous,",
            "Y’en a chez la voisine",
            "Mais ce n’est pas pour nous",
        ]),
        ("narrator_resume",),
        ("stanza", [
            "Forever bound to you, as the ancient saying goes.",
            "We held hands that August night down Rue de la Harpe",
            "(Possibly before it changed its name)",
            "Talking at length about our dreams.",
            "The words you said — I couldn’t say them back.",
        ]),
        ("stanza", [
            "Forever will it take me to forget",
            "Your flash-flood tears of practised anguish",
            "That crashed silently into an oyster shell,",
            "Before parting ways and wishing well.",
            "That’s the thing about good intentions,",
            "They perform the job of paving stones.",
        ]),
        ("stanza", [
            "Our hotel had a bath that played Debussy,",
            "Pretentious — but it came recommended",
            "By one of your wet mates from Rugby or Cambridge.",
            "Forever shall I question my choices,",
            "But how long will this monster stay voiceless?",
        ]),
        ("stanza", [
            "Wrapped up in red and yellow tape,",
            "Hell-bent on an exit, praying for a saviour.",
            "A tell-tale sign of malaise when we don’t",
            "Talk of rain because we’ve come to expect it.",
        ]),
        ("stanza", [
            "A long winter of mishaps and setbacks",
            "Trilled with flashes and hot spells,",
            "So you don’t forget how that feels.",
            "The type of winter that makes you consider",
            "Whether there’s anything keeping you here",
            "For the rest of your pertinent years.",
        ]),
        ("stanza", [
            "Is it folly to believe that hollow trees",
            "Should uproot and change locations?",
            "I was waiting in the lobby with some carnations",
            "Preparing to update my status when you entered.",
        ]),
        ("stanza", [
            "You popped back to the office to meet Patrick",
            "And thought I was still shopping in the spot",
            "With the black and white film posters. I was not.",
            "You’re no Cecil Northcote Parkinson, big shot,",
            "I’m not a resource you can delegate.",
        ]),
        ("stanza", [
            "Disbelieving glances at your wristwatch,",
            "You’re at a complete loss, she must be late.",
            "Seeing your mistress for the first time",
            "Reminded me of seeing your porn history,",
            "It both mystified and humoured me.",
        ]),
        ("stanza", [
            "I knew you weren’t the love I was seeking and",
            "You threw me that ring while your ship was leaking,",
            "That I would soon be leaving, but this twist",
            "Came sooner than even my most pessimistic",
            "Line of thinking, I’m kind of impressed.",
        ]),
        ("speaker", "Girls"),
        ("stanza", [
            "Dansons la capucine,",
            "Y’a pas de vin chez nous,",
            "Y’en a chez la voisine",
            "Mais ce n’est pas pour nous",
        ]),
        ("narrator_resume",),
        ("stanza", [
            "We smoked a fatty on the walk back from",
            "Montmartre to your flat in Batignolles,",
            "I’m normally nervous on a first date",
            "But there was something in the laidback way",
            "You pulled it out and gave it to me",
            "That I found impossible to turn away.",
        ]),
        ("stanza", [
            "You told me you knew every road in town,",
            "Where to breakfast, lunch and dine like locals,",
            "Which unfiltered cigarettes I should smoke",
            "And what folk I should avoid late night",
            "(Generally anybody with shaved heads,",
            "Long dreads or offerers of narcotics,",
            "Which in hindsight is ironic as it’s",
            "The only advice that was correct).",
        ]),
        ("stanza", [
            "Something poetic about a December exit",
            "After a sunny summery entrance.",
            "I left and was struggling to comprehend",
            "What had just happened and if it’s too soon to text.",
            "Even now I find it hard to explain,",
            "I don’t know the French for walk of shame.",
        ]),
        ("speaker", "Girls"),
        ("stanza", [
            "Dansons la capucine,",
            "Y’a du plaisir chez nous",
            "On pleure chez la voisine",
            "On rit toujours chez nous",
        ]),
        ("narrator_resume",),
        ("stanza", [
            "For every word I write another",
            "Seeks to follow, my pencil presses red hot",
            "Lead devouring paper. I can’t stop.",
            "Here’s the rub Prince, I’m going back to England.",
            "Our union was brief and now it’s ended.",
        ]),
        ("stanza", [
            "There’s nothing left to say, ring’s in the safe,",
            "I’ve been trying to give it back since September.",
            "Don’t think you’ve hurt me, I’m impervious,",
            "From my very earliest memories",
            "I’ve only been afraid of purgatory —",
            "The curbed suburbs of Surbiton.",
        ]),
        ("stanza", [
            "I’ve heard the girls, now it’s Pluto Shervington,",
            "Lord! Anybody see my trial? Grief for I.",
            "Why judge, I was badly beaten, found by",
            "Loved ones, battered by an irate husband,",
            "Searching for a man that was not I.",
        ]),
        ("stanza", [
            "Your honour was presented fraudulently.",
            "Your humour is offensive, not the good way.",
            "Dieu soit loué, I finally know now",
            "I must excise this bloated growth,",
            "This ghastly Esthesioneuroblastoma.",
        ]),
        ("stanza", [
            "Choose to disappear into my own night",
            "on the tail of dear Chantal Sébire,",
            "Before I lose my five senses",
            "Forever, farewell.",
        ]),
    ],
}


SCENE_10 = {
    "act": "Act Three",
    "act_subtitle": "Holy Saturday",
    "number": "10",
    "title": "The Masque of Anarchy",
    "setting": "Sunset. The new band play the opening gig of their tour.",
    "blocks": [
        ("speaker", "Cosmo"),
        ("stanza", [
            "I drowned in April, water took the sting out,",
            "Spezia swallowed every password that I owned.",
            "No login for the dead, no inbox, no analytics,",
            "Just salt and wood and months of letting go.",
        ]),
        ("stanza", [
            "You lot wear your faces like a lanyard,",
            "Swiping in and out of every lit-up room,",
            "Performing for the aperture, the lens cap",
            "On your hearts, exposure set to bloom and consume.",
        ]),
        ("stanza", [
            "I burned mine at the waterline and floated,",
            "Nameless in the undertow, devoted",
            "To the absence, to the beautiful unquoted",
            "Life that starts when every account is closed.",
        ]),
        ("stanza", [
            "Soft power is the hand that rocks the cradle",
            "And the grave, the algorithm lullaby.",
            "I wore the mask so long I lost my teeth to it,",
            "Now I’m grinning at you with an empty mouth,",
            "Daring you to recognise the smile.",
        ]),
        ("speaker", "Tom"),
        ("stanza", [
            "Why did we all let it come to this?",
            "Why did we all let it come to this?",
            "Why did we all let it come to this?",
            "Why did we all let it come to this?",
        ]),
        ("speaker", "Joly"),
        ("stanza", [
            "I drink the way my father talks, in rounds,",
            "One for the nerves, one for the shame, one for the sound",
            "Of nothing in a house where no one’s home by ten,",
            "I’m pouring doubles into single measures of a man.",
        ]),
        ("stanza", [
            "My old man built the label off the back of broken artists,",
            "I built nothing off the back of him, I’m harvest",
            "From a vineyard that he planted just to watch the rot,",
            "He looks at me and sees the vintage that he’s not.",
        ]),
        ("stanza", [
            "I held my brother’s coffin knowing there was nothing in it,",
            "Shouldered all that empty weight and didn’t flinch,",
            "I’ve been carrying nothing my entire life and calling it a living,",
            "The pallbearer with no body and no witness.",
        ]),
        ("stanza", [
            "I’m not a rapper and I’m not my brother’s keeper",
            "And I’m not my father’s heir tonight, I’m evidence",
            "That something grows in soil that was never meant for planting,",
            "So I’m gonna let it out before it puts me in the ground.",
        ]),
        ("stage", "Cosmo signals for the music to stop."),
        ("speaker", "Cosmo"),
        ("stanza", [
            "Faces wholly beshrouded in red-dyed dowlas,",
            "Baseless holy growlings like Howl on laughing gas.",
            "Ephemeral performances unetherised,",
            "Everyone knew they were part of “History”,",
            "Besides the reformed deceased, they know fame is misery.",
        ]),
        ("stanza", [
            "We mourn them ceaselessly, the sewers of livery,",
            "Playing to gaunt hands and cerebral thought police,",
            "On trial for obscenities, lovers of free speech.",
            "Surge too fast and catch chills in the church, go too slow it’s heatstroke.",
            "Either way one’s for it, this we know",
        ]),
        ("stanza", [
            "But the urge to purge for weddings and funerals",
            "Keeps us fainting-fit til we crumple like rag dolls,",
            "Beautiful jackals face-painting Roman numerals",
            "On to their public facades like macabre murals.",
        ]),
        ("stanza", [
            "Now the monomyth is the monolith.",
            "In London Town we rest our eyes on",
            "A Gherkin, a Walkie-talkie, a Shard and a prison.",
            "Now is the winter of our discontent",
            "Made colder by coin, this son of Satan.",
        ]),
        ("stanza", [
            "Sound debates unrationalised by fictions sold as fact,",
            "Public needs unnationalised by yahoos.",
            "Behind the wool masque is a blank face like yours.",
            "No fate is insurmountable, but I still stay unaccountable.",
            "They fear the Red Death so I wear it to chill them,",
            "Addicted to killing, illimitable dominion.",
        ]),
        ("stanza", [
            "They sell you back your face and call it content,",
            "Your likeness licensed, every click consent.",
            "Cashed in rehashed weapon caches, spent",
            "On wars reframed before the smoke is spent.",
        ]),
        ("stanza", [
            "Dispatch the harriers and turn them to ash.",
            "Earn your repast and slash the ruling classes.",
            "Murder your past and depart to new parts.",
            "I offer a new start, an antidote to ‘sanity’.",
            "To those that asked, I grant a counterpart reality.",
        ]),
        ("stage", "Cosmo removes his mask."),
        ("prose", "Some of you know the purpose of your presence here tonight, some are caught blindsided. In a moment we shall hand round a solution, so those who choose to join us shall suffer no sickness in transit."),
        ("stage", "Petrol canisters are brought on stage with bottles of vodka."),
        ("prose", "Those that wish to stay may drink too, but it may hasten your combustion. There’s not much left to say but that it’s better to burn out in an ecstasy of joy and rage than fade away in the eternal raptures of vertigo."),
        ("stage", "Petrol is poured on stage and around the building."),
        ("speaker", "Cosmo"),
        ("prose", "We flee this arid plain and set our lands in order. Represent. Shantih."),
        ("stage_centred", "screams"),
        ("speaker", "Destiny"),
        ("prose", "That’s not what I asked you."),
        ("loop_close", "Iced boots and coats defrosted in a hot Sunset…"),
    ],
}


# ---------------------------------------------------------------------------
# Rendering
# ---------------------------------------------------------------------------

def render_blocks(blocks):
    out = []
    for block in blocks:
        kind = block[0]
        if kind == "setting":
            out.append(f'<p class="scene-setting">{block[1]}</p>')
        elif kind == "stage":
            out.append(f'<p class="stage">{block[1]}</p>')
        elif kind == "stage_centred":
            out.append(f'<p class="stage stage-centred">{block[1]}</p>')
        elif kind == "speaker":
            out.append(f'<p class="speaker">{block[1]}</p>')
        elif kind == "narrator_resume":
            out.append('<div class="narrator-resume"></div>')
        elif kind == "stanza":
            lines = "\n".join(f'<span class="line">{ln}</span>' for ln in block[1])
            out.append(f'<div class="stanza">{lines}</div>')
        elif kind == "prose":
            out.append(f'<p class="prose">{block[1]}</p>')
        elif kind == "loop_close":
            out.append(f'<p class="loop-close">{block[1]}</p>')
    return "\n".join(out)


def render_scene(scene, first_in_act=False):
    parts = []
    if first_in_act and "act" in scene:
        parts.append('<div class="act-break">')
        parts.append(f'<h1 class="act-heading">{scene["act"]}</h1>')
        if "act_subtitle" in scene:
            parts.append(f'<p class="act-subtitle">{scene["act_subtitle"]}</p>')
        parts.append("</div>")
    parts.append('<section class="scene">')
    parts.append(f'<h2 class="scene-heading">'
                 f'<span class="scene-number">{scene["number"]}</span> '
                 f'<span class="scene-title">{scene["title"]}</span>'
                 f'</h2>')
    parts.append(f'<p class="scene-setting">{scene["setting"]}</p>')
    parts.append(render_blocks(scene["blocks"]))
    parts.append("</section>")
    return "\n".join(parts)


HTML_BODY = f"""
<!doctype html>
<html lang="en">
<head><meta charset="utf-8"><title>Soft Power — sample</title></head>
<body>

<section class="title-page">
  <h1 class="book-title">Soft Power</h1>
  <p class="book-author">Luke Warrington</p>
</section>

<section class="epigraph-page">
  <div class="epigraph">
    {'<br>'.join(EPIGRAPH)}
  </div>
  <p class="epigraph-credit">{EPIGRAPH_CREDIT}</p>
</section>

{render_scene(SCENE_1, first_in_act=True)}

{render_scene(SCENE_2, first_in_act=False)}

<div class="ellipsis-page">
  <p class="ellipsis">…</p>
  <p class="ellipsis-note">Scenes 3 – 9 omitted from this sample.</p>
</div>

{render_scene(SCENE_10, first_in_act=True)}

</body>
</html>
"""


CSS_BOOK = """
@page {
  size: 148mm 210mm;  /* A5 */
  margin: 22mm 18mm 24mm 18mm;
  @bottom-center {
    content: counter(page);
    font-family: "Bitstream Charter", "Charter", "Liberation Serif", serif;
    font-size: 9pt;
    color: #555;
  }
}

@page :first {
  @bottom-center { content: none; }
}

@page title-page { @bottom-center { content: none; } }

html { font-size: 11pt; }

body {
  font-family: "Bitstream Charter", "Charter", "Liberation Serif", "DejaVu Serif", serif;
  font-size: 11pt;
  line-height: 1.45;
  color: #111;
  hyphens: manual;
}

/* ---------- Title page ---------- */

.title-page {
  page: title-page;
  text-align: center;
  page-break-after: always;
  padding-top: 38mm;
}
.book-title {
  font-size: 26pt;
  font-weight: normal;
  letter-spacing: 0.05em;
  margin: 0 0 6mm 0;
}
.book-author {
  font-size: 13pt;
  font-style: italic;
  margin: 0;
}

/* ---------- Epigraph page ---------- */

.epigraph-page {
  page-break-after: always;
  padding-top: 50mm;
}
.epigraph {
  text-align: center;
  font-style: italic;
  font-size: 11pt;
  line-height: 1.7;
}
.epigraph-credit {
  text-align: center;
  margin-top: 6mm;
  font-style: italic;
  font-size: 10pt;
  color: #444;
}

/* ---------- Act and scene headings ---------- */

.act-break {
  page-break-before: always;
  text-align: center;
  padding-top: 40mm;
  page-break-after: always;
}
.act-heading {
  font-size: 16pt;
  font-weight: normal;
  font-variant-caps: small-caps;
  letter-spacing: 0.08em;
  margin: 0 0 3mm 0;
}
.act-subtitle {
  font-style: italic;
  font-size: 11pt;
  margin: 0;
  color: #444;
}

.scene {
  page-break-before: always;
}
.scene-heading {
  margin: 0 0 2mm 0;
  font-weight: normal;
  font-size: 13pt;
}
.scene-number {
  font-variant-caps: small-caps;
  letter-spacing: 0.05em;
  color: #777;
  margin-right: 0.6em;
}
.scene-title {
  font-style: italic;
}
.scene-setting {
  font-style: italic;
  font-size: 10pt;
  color: #444;
  margin: 0 0 6mm 0;
}

/* ---------- Speakers, stage directions, narrator ---------- */

.speaker {
  text-transform: uppercase;
  letter-spacing: 0.14em;
  font-size: 9pt;
  color: #222;
  margin: 5mm 0 1.5mm 0;
  text-indent: 0;
  font-weight: normal;
}

.stage {
  font-style: italic;
  color: #555;
  font-size: 10pt;
  margin: 2mm 0 2mm 0;
  text-indent: 0;
}

.stage-centred {
  text-align: center;
  letter-spacing: 0.4em;
  font-variant-caps: small-caps;
  color: #333;
  margin: 6mm 0;
}

.narrator-resume {
  height: 3mm;
}

/* ---------- Verse ---------- */

.stanza {
  margin: 0 0 3mm 0;
}
.line {
  display: block;
  text-indent: 0;
  padding-left: 1.4em;
  text-indent: -1.4em;  /* hanging indent for runover lines */
}

/* ---------- Prose ---------- */

.prose {
  margin: 1mm 0 3mm 0;
  text-indent: 0;
}

/* ---------- Loop close ---------- */

.loop-close {
  margin: 10mm 0 0 0;
  text-align: center;
  font-style: italic;
  font-size: 10pt;
  color: #777;
  letter-spacing: 0.02em;
}

/* ---------- Ellipsis page ---------- */

.ellipsis-page {
  page-break-before: always;
  page-break-after: always;
  text-align: center;
  padding-top: 70mm;
}
.ellipsis {
  font-size: 24pt;
  letter-spacing: 0.4em;
  margin: 0 0 4mm 0;
  color: #888;
}
.ellipsis-note {
  font-style: italic;
  font-size: 10pt;
  color: #555;
}
"""


def main():
    html = HTML(string=HTML_BODY, base_url=str(OUT_DIR))
    css = CSS(string=CSS_BOOK)
    html.write_pdf(PDF_PATH, stylesheets=[css])
    print(f"Wrote {PDF_PATH} ({PDF_PATH.stat().st_size} bytes)")


if __name__ == "__main__":
    main()
