using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class oneScript : faceScript
{


    override public int rollEffect(int a)
    {
        int faceValue = 1;

        a += faceValue;

        return a;
    }

    override public void clickEffect(GameObject target = null)
    {

    }


}
