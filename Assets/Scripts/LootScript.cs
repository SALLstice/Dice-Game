using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LootScript : MonoBehaviour
{
    public GameObject newLootPanel;
    private SpriteRenderer lootRend;
    public Sprite[] lootList;
    public int LOOT_COUNT = 3;
    private int x = 110;
    private int randFaceType;

    void Start()
    {
        this.gameObject.SetActive(false);
    }

    void OnEnable()
    {
        foreach (Transform child in this.transform)
        {
            if (child.name != "Text" & child.name != "skipLootButton")
            {
                GameObject.Destroy(child.gameObject);
            }
        }

        for (int i = 0; i < LOOT_COUNT; i++)
        {
            var thingyidk = GameObject.Find("Dice Sides").GetComponent<diceSidesScript>();
            var thingy2 = thingyidk.randFace();

            var testobj = Instantiate(thingy2, newLootPanel.transform);

            if (thingy2.name == "blank") 
            {
                randFaceType = -1;
            }
            else 
            {
                randFaceType = UnityEngine.Random.Range(0, 4);
            }

            testobj.GetComponent<faceScript>().type = randFaceType;
            if (randFaceType == 0)
            {
                testobj.GetComponent<SpriteRenderer>().color = Color.red;
            }
            else if (randFaceType == 1)
            {
                testobj.GetComponent<SpriteRenderer>().color = Color.grey;
            }
            else if (randFaceType == 2)
            {
                testobj.GetComponent<SpriteRenderer>().color = Color.green;
            }
            else if (randFaceType == 3)
            {
                testobj.GetComponent<SpriteRenderer>().color = Color.blue;
            }

            testobj.transform.localPosition = new Vector3(-230 + x * i, -49, -1);
            testobj.transform.localScale = new Vector3(160, 160, 160);
            testobj.GetComponent<SpriteRenderer>().sortingLayerName = "UI";

            

        }    
    }
}


