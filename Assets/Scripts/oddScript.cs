using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class oddScript : faceScript
{


    override public int rollEffect(int a = 0)
    {
        if (a % 2 == 1)
        {
            a *= 3;
        }

        return a;
    }

    override public void clickEffect(GameObject target = null)
    {

    }



}
