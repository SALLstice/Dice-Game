using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class evenScript : faceScript
{
    int MULTIPLIER = 2;


    override public int rollEffect(int a = 0)
    {
        if (a % 2 == 0)
        {
            a *= MULTIPLIER;
        }

        return a;
    }

    override public void clickEffect(GameObject target = null)
    {

    }



}
