using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class faceScript : MonoBehaviour
{
    public int WEIGHT;
    public int PRIORITY; 
    /* -1 no roll effect (not even checked)
     * 0 blank bonus
     * 1 numbers, spring winders
     * 2 even/odd, spring, 
     * 3 converters
     */
    public int type;
    /* -1 blank 
     * 0 attack
     * 1 defend  
     * 2 heal 
     * 3 magic   
     */
    public string state;
    public bool needsTarget;
    public bool used = false;
    private GameObject actingface;

    GameObject dieHighlighter;
    GameObject invPanel;
    public GameObject gamePanel;
    GameObject PlayerDicePool;
    private GameObject player;

    private Transform invDie;
    private Transform invFace;
    private int lootidx = -1;

    public void Start()
    {

        var ic = GameObject.Find("invCanvas");


        foreach (Transform child in gamePanel.transform)
        {
            if (child.name == "Player")
            {
                player = child.gameObject;
            }
        }
        foreach (Transform child in player.transform)
        {
            if (child.name == "PlayerDicePool")
            {
                PlayerDicePool = child.gameObject;
            }
        }
        foreach (Transform child in ic.transform)
        {
            if (child.name == "InvPanel")
            {
                invPanel = child.gameObject;

            }
        }
        foreach (Transform child in invPanel.transform)
        {
            if (child.name == "DieHighlighter")
            {
                dieHighlighter = child.gameObject;
            }
        }
    }
    public void OnMouseDown()
    { 
        if (state == "loot")
        {
            dieHighlighter.GetComponent<DHS>().set(this.gameObject);
        }
        else if (state == "replace")
        {
            if (dieHighlighter.GetComponent<DHS>().isSet)
            {
                lootidx = this.transform.GetSiblingIndex();
                int invdieidx = (lootidx / 6);
                invDie = PlayerDicePool.transform.GetChild(invdieidx);
                int invfaceidx = (lootidx % 6);
                invFace = invDie.transform.GetChild(invfaceidx);
                var hiliteParent = dieHighlighter.transform.parent;

                dieHighlighter.GetComponent<DHS>().reset();
                Destroy(invFace.gameObject);

                //setnewface THSI IS SUPPOSED TO GO HERE
                //**********************************************
                


                
                var testobj = Instantiate(hiliteParent, invDie.transform);
                testobj.transform.localPosition = new Vector3(0, 0, 0);
                testobj.transform.localScale = new Vector3(1, 1, 1);
                testobj.transform.SetSiblingIndex(invfaceidx);
                testobj.gameObject.GetComponent<faceScript>().state = "inv";
                testobj.GetComponent<SpriteRenderer>().sortingLayerName = "Hidden";
                testobj.name = testobj.GetComponent<SpriteRenderer>().sprite.name;
                

                invPanel.SetActive(false);
                gamePanel.SetActive(true);
            }
        }
        else if (state == "inv")
        {
            if (!this.GetComponent<faceScript>().used)
            {
                if (dieHighlighter.GetComponent<DHS>().isSet)
                {
                    var actingdie = dieHighlighter.transform.parent;
                    var actingshowingidx = actingdie.GetComponent<Dice>().showingIdx;
                    var actingface = actingdie.transform.GetChild(actingshowingidx);

                    if (actingface.GetComponent<faceScript>().needsTarget)
                    {


                        actingface.GetComponent<faceScript>().clickEffect(this.gameObject);
                    }
                    else
                    {
                        actingface.GetComponent<faceScript>().clickEffect();

                    }


                }
                else
                {

                    dieHighlighter.GetComponent<DHS>().set(this.transform.parent.gameObject);

                }
            }
        }
    }

    public virtual void reset() {}
    public virtual int rollEffect(int a = 0) { return -1; }
    public virtual void clickEffect(GameObject target = null) {  }

}

public class diceSidesScript : MonoBehaviour
{
    private int WEIGHT_TOTAL = 0;
    List<int> weights = new List<int>();
    private bool found = false;
    private int faceIdx = -1;

    // Start is called before the first frame update
    void Start()
    {
        weights.Clear();
        foreach (Transform child in transform)
        {
            int tempweight = child.gameObject.GetComponent<faceScript>().WEIGHT;

            WEIGHT_TOTAL += tempweight;
            weights.Add(tempweight);
        }
    }

    public GameObject randFace()
    {
        found = false;
        faceIdx = -1;
        int i = 0;
        int x = UnityEngine.Random.Range(0, WEIGHT_TOTAL);

        faceIdx = 0;

        while (!found & weights.Count > 0)
        {
            if ((x -= weights[i]) < 0)
            {
                faceIdx = i;
                found = true;
                break;
            }
            if (i == weights.Count)
            {
                Debug.Log("count find face. you broke it. lmao");
                break;
            }

            i++;
        }

        return this.gameObject.transform.GetChild(faceIdx).gameObject;
    }
}
