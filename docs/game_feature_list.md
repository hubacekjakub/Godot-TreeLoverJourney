# Game Loop

## Levels
- player need to go through a number of levels, lets say 4

## Day Cycle
- stretcher automoves on path
- around path are supplies of various quantities (small, big)
- player need to send units (increasing count for each level) to collect them

## Night Cycle
- top down view of campsite
- among tents are packages with supplies
- on outer radius there are spawnpoints for enemies
- enemies spawn and try to approach resource box
- when resource box if reached - one resource (only ONE) per one enemy

## Resoruces
- wood: can increase fire at night, if there is enough fire, no enemies attack
- berries: you can heal debuffed units, but only after night cycle ends?

## Debuff
- when unit is lost during the day (is outside of the stretcher radius) it is lost
- lost unit is debuffed for a next day (penalization)

## Environment hazards
- during the day player can use slow shortcuts to get to better loot, but it will cost time and unit can get lost (nav-links with speed debuff)
- during the day player can get trapped in envronment hazard (quicksand?, swamp?) and lose units

## Game Cycle:

### Intro Cutscene:
- a kakapo is comes to the tree and attemps to clib it, falls down, injuring its leg
- other kakapo friends bring stretcher to help
- there is introduction text explaining some facts about kakapos

### Day One Cycle:
- stretcher automoves on path
- 2 units are running around to collect resources
- stretcher need to reach the campsite
- no environment hazards
- big stretcher effective radius, its like tutorial level
- during the night enemies are less frequent, player has a time to learn how this mechanics works

### Day Two Cycle:
- stretcher automoves on path
- 3 units are running around to collect resources
- stretcher need to reach the campsite
- one environment hazard (only slow down, no unit loss hazard)
- stretcher radius is smaller, player need to be more careful
- more frequent enemies during the night

### Day Three Cycle:
- WIP

### Outro Cutscene:
- kakapo is healed and can refreshsed
- game ends with kakapo comming to the same tree as in intro, looking up with love
- small funny about kakapos and how they never learn
