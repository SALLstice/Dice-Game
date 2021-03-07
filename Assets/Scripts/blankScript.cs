using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class blankScript : faceScript
{


    override public int rollEffect(int a)
    {
        //int faceValue = player.GetComponent<PlayerScript>().blankValue;
        //a += faceValue;

        a += 1; //inc number of blanks

        return a;
    }

    override public void clickEffect(GameObject target = null)
    {

    }

    

}
