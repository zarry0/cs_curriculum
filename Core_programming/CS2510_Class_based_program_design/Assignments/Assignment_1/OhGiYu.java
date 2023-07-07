import tester.Tester;

/*
 * Problem 3:
 * We’ve been asked to help build a new, totally original, deck-building game, Oh-Gi-Yu. 
 * To start, we’re designing representations for the resources a player can have and 
 * the actions they can take during their turn.
 * A player can have three kinds of resources: 
 *      - Monster, 
 *      - Fusion, and 
 *      - Trap.
 * 
 * A Monster has:   name, such as Bright Magician, 
 *                  hp (short for hit points, measured as an integer), and 
 *                  an attack rating (measured as an integer).
 * Fusion has:      name, such as Green-Eyes Epic Dragon, 
 *                  monster1 and a monster2 of which it is comprised. 
 *                  Note that these can only be Monsters, not other Fusions.
 * A Trap has:      some description and 
 *                  a flag continuous denoting whether its effect is instant or occurs over a period of time.
 * 
 * As the game is under construction, the player can only perform two kinds of actions right now: 
 *      - they can Attack one monster with another (be it a fusion or non-fusion monster), 
 *      - or they can Activate a trap card.
 * 
 * An Attack involves an attacker and a defender, both of which are monster resources (as in, not trap cards). 
 * To succesfully attack, the attacker’s attack value must be worth more than the defender’s hp.
 * A Fusion’s HP and attack is derived from the sum of its monsters’ HP and attack. 
 * Note: You do not have to implement this calculation in code.
 * Be sure to only define examples Attacks that are successful.
 * 
 * An Activate has a trap (which should be a Trap) and a target (a monster, fusion or otherwise) it is targeting.
 * 
 * Define six examples of resources, including:
 *      - kuriboh: name "Kuriboh", hp 200, attack 100
 *      - jinzo: name "Jinzo", hp 500, attack 400
 *      - kurizo: name "Kurizo", monster1 kuriboh, monster2 jinzo
 *      - trapHole: description "Kills a monster", not contiunous
 * The others can be whatever you wish.
 * 
 * Define four types of actions, two of each kind.
 * Name your action examples attack1, attack2, activate1, activate2, etc., and your examples class ExamplesGame.
 * 
 * Design:
 * 
 *      Note that we have described a data definition which groups monsters, fusions, and trap cards all as resources. 
 *      Keeping in mind the actions described above, was this a good data design? If so, why, and if not, why not? 
 *      Leave a brief comment below your examples in your examples class with your answer, 
 *      and if you think it’s a poor design choice, briefly theorize about an alternative design that would make more sense.
 */

/*
 * Class diagram
 * 
 * 


                                +-----------+
   +--------------------------->| IResource |
   |                            |-----------|
   |                            +-----------+
   |                                  |
   |                                 / \
   |                                 ---
   |                                  |
   |           +----------------------+----------------------+
   |           |                      |                      |
   |    +-------------+     +--------------------+  +--------------------+
   |    | Monster     |     | Fusion             |  | Trap               |
   |    |-------------|     |--------------------|  |--------------------|
   |    | String name |     | String name        |  | String description |
   |    | int hp      |  +--+ IResource monster1 |  | boolean continuous |
   |    | int atk     |  +--+ IResource monster2 |  +--------------------+
   |    +-------------+  |  +--------------------+
   |                     |
   |---------------------+       +---------+
   |                             | IAction |
   |                             |---------|
   |                             +---------+
   |                                  |
   |                                 / \
   |                                 ---
   |                                  |
   |                     +-------------------------+
   |                     |                         |
   |           +--------------------+     +------------------+
   |           | Attack             |     | Activate         |
   |           |--------------------|     |------------------|
   +-----------+ IResource attacker |  +--+ IResource trap   |
   +-----------+ IResource defender |  +--+ IResource target |
   |           +--------------------+  |  +------------------+
   |                                   |
   +-----------------------------------+


*/

// to represent a player resource
interface IResource { }

class Monster implements IResource {
    String name;
    int hp;
    int atk;

    Monster(String name, int hp, int atk) {
        this.name = name;
        this.hp = hp;
        this.atk = atk;
    }
}

class Fusion implements IResource {
    String name;
    IResource monster1;
    IResource monster2;

    Fusion(String name, IResource monster1, IResource monster2) {
        this.name = name;
        this.monster1 = monster1;
        this.monster2 = monster2;
    }
}

class Trap implements IResource {
    String description;
    boolean continuous;

    Trap(String description, boolean continuous) {
        this.description = description;
        this.continuous = continuous;
    }
}

// to represent a player action
interface IAction { }

class Attack implements IAction {
    IResource attacker;
    IResource defender;

    Attack(IResource attacker, IResource defender) {
        this.attacker = attacker;
        this.defender = defender;
    }
}

class Activate implements IAction {
    IResource trap;
    IResource target;

    Activate(IResource trap, IResource target) {
        this.trap = trap;
        this.target = target;
    }
}

class ExamplesGame {
    IResource kuriboh = new Monster("Kuriboh", 200, 100);
    IResource jinzo = new Monster("Jinzo", 500, 400);
    IResource kurizo = new Fusion("Kurizo", kuriboh, jinzo);
    IResource trapHole = new Trap("Kills a monster", false);
    IResource trapRevive = new Trap("Revives a monster form the cementary", true);
    IResource blueEyeDragon = new Monster("Blue-Eyes White Dragon", 2500, 3000);

    IAction attack1 = new Attack(blueEyeDragon, jinzo);
    IAction attack2 = new Attack(kurizo, kuriboh);
    IAction activate1 = new Activate(trapHole, jinzo);
    IAction activate2 = new Activate(trapRevive, kurizo);

    /*  Was this a good data design?
     *  This is an OK design, but the Monster and Fusion types are more closely related
     *  to each other than the Trap type is. 
     *  One improvement I can think of is to make a Monster union type that includes the 
     *  primary Monster type and the fusion type and then use this new data definition 
     *  inside de IResource type along with Trap.
    */

}