# Team 1 - Crescendo

A haptically augmented music notation viewer.

## Boilerplate

This has basically become the structure for the main sketch.
It consists of a good number of files but they are organized:

- boilerplate : The objects defining the example score, setting up Haply, and running.
- Clef : The Clef class declaration.
- Duration : Things related to note/rest durations and how to use them.
- Enumerations : A lot of useful enumerations like clef shapes and accidentals.
- Interfaces : The interfaces for the different modalities. `Audible`, `Tangible`, and `Viewable`.
- Note : The Note class declaration.
- OrderedMusicElement : The OrderedMusicElement class that all music elements are children of.
This describes the shared behavior of all musical elements.
- Panto : Helpful things related to the pantograph animation and physics. Kept separately for neatness.
- Pantograph.java : Description of pantograph mechanism.
- Rest : The Rest class declaration.
- Score : The Score class declaration. This also handles rendering for its child elements (i.e., the music).
- TimeSignature : The TimeSignature class declaration.
