using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class blankBonusScript : faceScript
{

    public GameObject player;

    override public int rollEffect(int a = 0)
    {
        //player.GetComponent<PlayerScript>().blankValue += 3;
        a += player.GetComponent<PlayerScript>().blankCount * 3;

        return a;
    }

    override public void clickEffect(GameObject target = null)
    {

    }

 

}
