using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class bombScript : faceScript
{
    public GameObject blank;
    public GameObject player;
    public GameObject monster;
    public GameObject dieHighlighter;

    override public void clickEffect(GameObject target)
    {
        if(dieHighlighter.GetComponent<DHS>().isSet)
        {
            int targetidx = target.gameObject.transform.GetSiblingIndex();
            int actoridx = this.gameObject.transform.GetSiblingIndex();
            var targetdie = target.gameObject.transform.parent;
            var actordie = this.gameObject.transform.parent;

            

            GameObject.Destroy(target.gameObject);
            GameObject.Destroy(this.gameObject);

            var blankface = GameObject.Find("Dice Sides");

            targetdie.GetComponent<Dice>().setNewFace(blank, targetidx, "inv", "Default");
            actordie.GetComponent<Dice>().setNewFace(blank, actoridx, "inv", "Default");

            targetdie.GetComponent<Dice>().setDieFace(targetidx);
            actordie.GetComponent<Dice>().setDieFace(actoridx);

            dieHighlighter.GetComponent<DHS>().reset();
            player.GetComponent<PlayerScript>().calcDieTotal();
            monster.GetComponent<MonsterScript>().calcDieTotal();
        }
        else
        {
            
        }
    }

    

}
