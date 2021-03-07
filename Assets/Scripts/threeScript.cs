using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class threeScript : faceScript
{

    override public int rollEffect(int a)
    {
        int faceValue = 3;

        a += faceValue;

        return a;
    }

    override public void clickEffect(GameObject target = null)
    {

    }



}
