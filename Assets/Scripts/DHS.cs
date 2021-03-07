using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DHS : MonoBehaviour
{
    public bool isSet = false;
    public GameObject invPanel;

    public void set(GameObject target)
    {
        string parentLayer = target.gameObject.GetComponent<SpriteRenderer>().sortingLayerName;
        int parentOrder = target.gameObject.GetComponent<SpriteRenderer>().sortingOrder;

        this.gameObject.transform.parent = target.gameObject.transform;
        this.gameObject.transform.localPosition = new Vector3(0, 0, -1);
        this.gameObject.transform.localScale = new Vector3(1.2f, 1.2f, 1.2f);
        this.gameObject.GetComponent<SpriteRenderer>().sortingLayerName = parentLayer;
        this.gameObject.GetComponent<SpriteRenderer>().sortingOrder = parentOrder - 1;
        isSet = true;
    }

    public void reset()
    {
        this.gameObject.GetComponent<SpriteRenderer>().sortingLayerName = "Hidden";
        this.gameObject.transform.parent = invPanel.transform;
        isSet = false;
    }
}
