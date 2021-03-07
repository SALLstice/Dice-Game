using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class invFaceScript : MonoBehaviour
{
    //public GameObject newLootDie;
    public GameObject player;
    private Transform invDie;
    private Transform invFace;
    private int lootidx = -1;
    public GameObject invPanel;
    public GameObject gamePanel;
    public GameObject newLootPanel;
    public GameObject dieHighlighter;
    public GameObject invLayoutPanel;
    
    public void OnMouseDown()
    {
        if (dieHighlighter.GetComponent<DHS>().isSet)
        {
            lootidx = this.transform.GetSiblingIndex();
            int invdieidx = (lootidx / 6);
            invDie = player.transform.GetChild(invdieidx);
            int invfaceidx = (lootidx % 6);
            invFace = invDie.transform.GetChild(invfaceidx);
            var hiliteParent = dieHighlighter.transform.parent;

            dieHighlighter.GetComponent<DHS>().reset();
            Destroy(invFace.gameObject);

            //setnewface THSI IS SUPPOSED TO GO HERE
            //**********************************************
            
            /*
            var testobj = Instantiate(hiliteParent, invDie.transform);
            testobj.transform.localPosition = new Vector3(0, 0, 0);
            testobj.transform.localScale = new Vector3(1, 1, 1);
            testobj.transform.SetSiblingIndex(invfaceidx);
            testobj.gameObject.GetComponent<faceScript>().state = "inv";
            testobj.GetComponent<SpriteRenderer>().sortingLayerName = "Hidden";
            testobj.name = testobj.GetComponent<SpriteRenderer>().sprite.name;
            */

            invPanel.SetActive(false);
            gamePanel.SetActive(true);
        }
    }
}
