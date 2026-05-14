# Soft Power — Submission Handoff

A snapshot of the publication campaign as of this branch. Pick up here.

## What the campaign is

Cold-submitting *Soft Power* to three UK literary agents and (in parallel)
six literary magazines. The book is a verse drama, 80 pages typeset,
complete in V2 draft. The poet has personal connections to two agents
(Pelham at Marjacq, Maddy Price at Canongate) but both are deliberately
held — Pelham because the friendship needs social repair before any work
ask; Price because Canongate Non-Fiction isn’t the list.

The strategy is documented in the `/literary-agent` skill at
`.claude/skills/literary-agent/SKILL.md`. Run the skill with no
argument for a fresh diagnostic if needed; with `query`, `comps`, `plan`,
`read`, `synopsis`, `bio`, or `tracker` for a specific mode.

## Materials in the repo

```
01 - Poem/
├── soft_power_v2.md                       # source manuscript
├── Typeset Sample/
│   ├── soft_power_sample.pdf              # the sample to attach
│   └── build_sample.py                    # rebuild with: python3 build_sample.py
└── Submission Materials/
    ├── synopsis.md                        # 1-paragraph and 1-page versions
    ├── cover-letter-paterson.md           # Aitken Alexander, Emma Paterson
    ├── cover-letter-caskie.md             # Robert Caskie Ltd
    ├── cover-letter-paget.md              # C&W Agency, Catriona Paget
    └── standalone-pieces/
        ├── README.md                      # per-magazine context-note guidance
        ├── mind-rain.md                   # Norah’s verse-letter
        ├── i-feel-no-guilt.md             # Ron Dox monologue
        └── beggars-news.md                # Beggar’s rant
```

## Three agent sends — status at handoff

| Agent | Agency | Address | Status |
|---|---|---|---|
| Emma Paterson | Aitken Alexander | `submissions@aitkenalexander.co.uk` | ✅ ready — subject `FAO Emma Paterson — Soft Power (verse drama in book form)` |
| Robert Caskie | Robert Caskie Ltd | `submissions@robertcaskie.com` | ✅ ready |
| Catriona Paget | C&W Agency | likely `catriona.submissions@cwagency.co.uk` | ⚠️ verify address on her profile page before sending |

All three are cold queries. The poet will personalise each opening line
when sending; the drafts in the cover-letter files are scaffolding, not
final copy.

## Pre-flight checklist

Before any send goes out:

- [ ] Open the typeset sample PDF on a real screen one last time
- [ ] Copy the one-paragraph synopsis from `synopsis.md` into Word, save
      as `synopsis.docx`
- [ ] Verify Paget’s actual submissions address on C&W’s site (the
      pattern guess is `catriona.submissions@cwagency.co.uk`; if only
      `catriona.paget@cwagency.co.uk` is listed, use that)

## Order of sends (when ready)

1. **Paterson first.** Strongest fit (Femi and Tempest are her clients).
2. **Caskie second.** Boutique principal, reads everything himself,
   reps Ellams. Honest caveat: his stated taste is literary fiction,
   not poetry. Send and see.
3. **Paget third.** Stretch on form (her wishlist is contemporary
   literary fiction, no poets) but right on content. Open submissions
   and works on Armstrong’s list.

All three on the same day or across two days; declared as simultaneous
in each letter.

## Six magazine sends — parallel track

Set up a Submittable account first (one-off, ~15 min). Then:

| Piece | Magazines | Context note |
|---|---|---|
| *Mind Rain* | The London Magazine + The White Review | Keep / Strip |
| *I Feel No Guilt* | PN Review + Magma | Keep / Keep |
| *Beggar’s News* | Bath Magg + Poetry London | None / None |

A single magazine acceptance lifts every agent letter by ~10 percentage
points. This is the highest-leverage thing to chase alongside the agents.

Per-magazine context-note guidance is in
`standalone-pieces/README.md`. Cover-note template is there too.

## Response windows

- Agents: 4–8 weeks for a read; longer for silence-as-no
- Magazines: 2–4 months typical, sometimes longer

Don’t chase before week 6 on agents. Don’t chase magazines at all
unless their stated response window has clearly passed.

## When responses start coming in

- **Full manuscript request from an agent:** big deal. The book has
  legs. Reply same day with the full manuscript (already complete in
  V2; export from `soft_power_v2.md` to .docx via pandoc or Word paste).
- **Form rejection:** expected median outcome. Don’t over-interpret.
- **Personalised rejection from an agent:** this is gold. Read it
  carefully. It usually tells you exactly what’s blocking a yes. Save
  the email and bring it into the next session.
- **Magazine acceptance:** add the credit to the bio (e.g., *“‘Mind
  Rain’ appeared in The London Magazine, summer 2026”*) and update
  the cover letters before re-firing.
- **Silence at week 8 on all three agents:** time for a re-think.
  Open the `/literary-agent` skill again and ask for `read` mode — a
  publication-focused editorial pass on what might be blocking. Then
  fire the week-four backups: Jin Auh at Wylie, Sophie Lambert at C&W
  *(only if Paget has explicitly passed — C&W rule is one agent per
  agency)*, and an indie press direct (Penned in the Margins).

## What’s deliberately held

- **Imogen Pelham (Marjacq).** Friend, Highgate alumna, long lapse in
  contact. Reach out socially first. Don’t use her as a cold-work
  contact.
- **Slix Fleeingham endorsement.** Worth more than another cold agent
  query, but the poet wants to wait until further down the line. The
  ask is small and high-value when it’s time.
- **Penned in the Margins.** Indie press direct submission, week 3
  earliest. Tom Chivers’ press has been quieter recently — verify
  they’re currently open before sending.

## Tracker

Add a simple table in `Submission Materials/tracker.md` once sends
begin. Date sent, agent or magazine, response (or week-X silence),
notes. Keep it boring and current.
