using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class springScript : faceScript
{
    public int WINDS_INC = 1;
    public int winds;
    public GameObject SpringLabel;
    public GameObject player;

    override public void reset()
    {
        SpringLabel.transform.parent.GetComponent<Canvas>().sortingLayerName = "Hidden";
        used = false;
        WINDS_INC = 1;
    }

    public void Awake()
    {
        //SpringLabel.transform.parent.GetComponent<Canvas>().overrideSorting = true;
        //SpringLabel.transform.parent.GetComponent<Canvas>().sortingLayerName = "UI";
    }

    override public int rollEffect(int a)
    {
        SpringLabel.transform.parent.GetComponent<Canvas>().sortingLayerName = "UI";

        if (used)
        {
            int bonus = winds;

            winds = 0;
            SpringLabel.GetComponent<Text>().text = winds.ToString();

            return a + bonus;
        }
        else
        {
            winds += WINDS_INC;
            SpringLabel.GetComponent<Text>().text = winds.ToString();
        }

        return a;
    }

    override public void clickEffect(GameObject target)
    {
        if (!used)
        {
            used = true;
            player.GetComponent<PlayerScript>().calcDieTotal();
        }
    }
}
