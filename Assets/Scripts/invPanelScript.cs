using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class invPanelScript : MonoBehaviour
{
    private List <SpriteRenderer> playerDiceRend = new List<SpriteRenderer>();
    public GameObject player;
    public GameObject PlayerDicePool;
    public GameObject invLootDie;
    public GameObject newLootPanel;
    public GameObject invLayoutPanel;
    public GameObject scrapLootLabel;
    public GameObject gamePanel;
    public int LOOT_COUNT = 3;
    private int x = 110;
    private int randFaceType;

    List<int> typeWeights = new List<int>();
    private bool found = false;
    private int ATK_LOOT_WEIGHT = 100;
    private int DEF_LOOT_WEIGHT = 50;
    private int HEAL_LOOT_WEIGHT = 20;
    private int MAG_LOOT_WEIGHT = 10;

    public int scrapLoot;

    void Start()
    {
        this.gameObject.SetActive(false);
        gamePanel.SetActive(true);
    }

    void OnEnable()
    {
        gamePanel.SetActive(false);
        
        int x = 110;
        int y = 110;
        int yCount = 0;
        int xCount = 0;

        generateLoot();
        
        foreach (Transform child in invLayoutPanel.transform)
        {
            GameObject.Destroy(child.gameObject);
        }

        foreach (Transform child in PlayerDicePool.transform) {
            if (child.CompareTag("Die"))
            {
                playerDiceRend.Clear();
                playerDiceRend.AddRange(child.GetComponentsInChildren<SpriteRenderer>());
                playerDiceRend.RemoveAt(0);
                
                foreach (SpriteRenderer playerdieFace in playerDiceRend)
                {
                    if (playerDiceRend[xCount].CompareTag("Face"))
                    {
                        
                        var testobj = Instantiate(child.transform.GetChild(xCount), invLayoutPanel.transform);
                        testobj.transform.localPosition = new Vector3(-310 + x * xCount, 120 - y * yCount, -1);
                        testobj.transform.localScale = new Vector3(160, 160, 160);
                        testobj.GetComponent<SpriteRenderer>().sortingLayerName = "UI";
                        testobj.GetComponent<SpriteRenderer>().sortingOrder = 1;
                        testobj.GetComponent<faceScript>().state = "replace";
                        testobj.GetComponent<SpriteRenderer>().sprite = child.GetChild(xCount).GetComponent<SpriteRenderer>().sprite;

                        foreach(Transform canvas in testobj.transform)
                        {
                            if(canvas.name == "Canvas")
                            {
                                canvas.GetComponent<Canvas>().overrideSorting = true;
                                canvas.GetComponent<Canvas>().sortingLayerName = "UI";
                            }
                        }

                        if (child.GetChild(xCount).GetComponent<faceScript>().type == -1)
                        {
                            testobj.GetComponent<SpriteRenderer>().color = Color.white;
                        }
                        if (child.GetChild(xCount).GetComponent<faceScript>().type == 0)
                        {
                            testobj.GetComponent<SpriteRenderer>().color = Color.red;
                        }
                        else if (child.GetChild(xCount).GetComponent<faceScript>().type == 1)
                        {
                            testobj.GetComponent<SpriteRenderer>().color = Color.grey;
                        }
                        else if (child.GetChild(xCount).GetComponent<faceScript>().type == 2)
                        {
                            testobj.GetComponent<SpriteRenderer>().color = Color.green;
                        }
                        else if (child.GetChild(xCount).GetComponent<faceScript>().type == 3)
                        {
                            testobj.GetComponent<SpriteRenderer>().color = Color.blue;
                        }

                        xCount++;
                        if (xCount >= 6)
                        {
                            xCount = 0;
                            yCount++;
                        }
                    }
                }
            }
        }
    }

    void generateLoot()
    {
        typeWeights.Clear();
        typeWeights.Add(ATK_LOOT_WEIGHT);
        typeWeights.Add(DEF_LOOT_WEIGHT);
        typeWeights.Add(HEAL_LOOT_WEIGHT);
        typeWeights.Add(MAG_LOOT_WEIGHT);

        foreach (Transform child in newLootPanel.transform)
        {
            if (child.name != "Text" & child.name != "skipLootButton")
            {
                GameObject.Destroy(child.gameObject);
            }
        }

        scrapLoot = 200 * LOOT_COUNT;
        
        for (int i = 0; i < LOOT_COUNT; i++)
        {
            var thingyidk = GameObject.Find("Dice Sides").GetComponent<diceSidesScript>();
            var thingy2 = thingyidk.randFace();
            var testobj = Instantiate(thingy2, newLootPanel.transform);
            scrapLoot -= thingy2.GetComponent<faceScript>().WEIGHT;

            if (thingy2.GetComponent<faceScript>().type == -1)
            {
                randFaceType = -1;
                scrapLoot -= 100;
            }
            else
            {
                int WEIGHT_TOTAL = ATK_LOOT_WEIGHT + DEF_LOOT_WEIGHT + HEAL_LOOT_WEIGHT + MAG_LOOT_WEIGHT;
                int randweight = UnityEngine.Random.Range(0, WEIGHT_TOTAL);
                int j = 0;
                found = false;
                randFaceType = 0;

                while (!found & typeWeights.Count > 0)
                {
                    if ((randweight -= typeWeights[j]) < 0)
                    {
                        randFaceType = j;
                        found = true;
                        scrapLoot -= typeWeights[j];
                    }

                    j++;
                }
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

            testobj.transform.localPosition = new Vector3(-130 + x * i, 0, -1);
            testobj.transform.localScale = new Vector3(160, 160, 160);
            testobj.GetComponent<SpriteRenderer>().sortingLayerName = "UI";
            testobj.GetComponent<SpriteRenderer>().sortingOrder = 2;

        }

        scrapLootLabel.GetComponent<Text>().text = scrapLoot.ToString();
    }
}

