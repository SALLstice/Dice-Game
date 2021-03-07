using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class lootFaceScript : MonoBehaviour
{
    public GameObject InvPanel;
    private GameObject newLootDie;
    public GameObject player;
    //private int y = -1;
    //private int x = -1;

    // Start is called before the first frame update
    void Start()
    {
        InvPanel.SetActive(false);
        newLootDie = GameObject.Find("newLootDie");
        //Debug.Log(newLootDie.name);
        player = GameObject.Find("Player");
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    /*public void OnMouseDown()
    {
        //
        InvPanel.SetActive(true);

        //this.transform.parent.gameObject.SetActive(false);
        player.transform.parent.gameObject.SetActive(false);
        
        newLootDie = GameObject.Find("newLootDie");
        newLootDie.GetComponent<SpriteRenderer>().sprite = this.GetComponent<SpriteRenderer>().sprite;

        this.transform.parent.gameObject.SetActive(false);

    }*/
}
