using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class rerollScript : faceScript
{

    public GameObject player;
    public GameObject monster;
    public GameObject dieHighlighter;

    override public void reset()
    {
        used = false;
    }

    override public int rollEffect(int a)
    {
        used = false;

        return a;
    }

    override public void clickEffect(GameObject target)
    {
        if (dieHighlighter.GetComponent<DHS>().isSet & !used)
        {
            int targetidx = target.gameObject.transform.GetSiblingIndex();
            int actoridx = this.gameObject.transform.GetSiblingIndex();
            var targetdie = target.gameObject.transform.parent;
            var actordie = this.gameObject.transform.parent;

            targetdie.GetComponent<Dice>().RollTheDie();

            dieHighlighter.GetComponent<DHS>().reset();
            player.GetComponent<PlayerScript>().calcDieTotal();
            monster.GetComponent<MonsterScript>().calcDieTotal();

            used = true;
        }
        else
        {

        }
    }



}
