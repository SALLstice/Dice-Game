using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class springsScript : faceScript
{
    public GameObject PlayerDicePool;

    override public int rollEffect(int a)
    {
        foreach(Transform die in PlayerDicePool.transform)
        {
            foreach(Transform face in die.transform)
            {
                if (face.name == "spring")
                {
                    face.GetComponent<springScript>().WINDS_INC++;

                }
                  
            }
        }   

        return a;
    }

    override public void clickEffect(GameObject target)
    {
       
    }
}
