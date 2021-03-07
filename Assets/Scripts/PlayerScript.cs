using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using System;

public class Creature : MonoBehaviour
{
    public GameObject GameManager;
    public GameObject InvPanel;
    public GameObject gamePanel;
    public GameObject DieTemplate;
    public GameObject DicePool;

    //public List<string, int> diePool = new List<string, int>();

    public GameObject atkLabel;
    public GameObject defLabel;
    public GameObject healLabel;
    public GameObject magicLabel;
    public GameObject hpLabel;
    public GameObject scrapLabel;
    public int hp;
    public int damage;
    public int defence;
    public int healing;
    public int magic;
    public int blankCount;
    public int blankValue;
    public int scrap;
    public int SCRAP_LIMIT = 300;

    public int PRIORITY_LEVEL_COUNT = 3;

    public void Awake()
    {
        hpLabel.GetComponent<Text>().text = hp.ToString() ;
    }

    public void repositionDice()
    {
        for (int i = 0; i < DicePool.transform.childCount; i++)
        {
            var parentPos = DicePool.transform.localPosition;
            //DicePool.transform.GetChild(i).transform.localPosition = new Vector3(-0.7f + (0.7f*i), -2, 0);
            DicePool.transform.GetChild(i).transform.localPosition = new Vector3(parentPos.x + (0.7f * i), 0, 0);

            //-0.1, -0.25
            // -1.35 -7.35 , 3


            DicePool.transform.GetChild(i).transform.localScale = new Vector3(1, 1, 1);

        }
    }

    public void RollAllDice()
    {

        foreach (Transform die in DicePool.transform)
        {
            if (die.tag == "Die")
            {
                die.GetComponent<Dice>().RollTheDie();
            }
        }
        calcDieTotal();
    }

    public void deleteAllDice()
    {
        foreach (Transform die in DicePool.transform)
        {
            if (die.tag == "Die")
            {
                Destroy(die.gameObject);
            }
        }
    }

    public void calcDieTotal()
    {
        blankCount = 0;
        //int atkTotal = 0;
        //int defTotal = 0;
        //int healTotal = 0;
        //int magicTotal = 0;
        int dieTotal = 0;

        for (int typeCount = -1; typeCount <= 3; typeCount++)
        {
            dieTotal = 0;
            for (int priorityCount = 0; priorityCount < PRIORITY_LEVEL_COUNT; priorityCount++)
            {
                foreach (Transform die in DicePool.gameObject.transform)
                {
                    if (die.tag == "Die")
                    {
                        int faceShowingIdx = die.gameObject.GetComponent<Dice>().showingIdx;
                        faceScript showingFaceScript = die.GetChild(faceShowingIdx).gameObject.GetComponent<faceScript>();

                        if (showingFaceScript.PRIORITY == priorityCount & showingFaceScript.type == typeCount)
                        {
                            dieTotal = showingFaceScript.rollEffect(dieTotal);
                        }
                    }
                }
            }
            if (typeCount == -1)
            {
                blankCount = dieTotal;
            }
            if (typeCount == 0)
            {
                atkLabel.GetComponent<Text>().text = dieTotal.ToString();
                damage = dieTotal;
            }
            if (typeCount == 1)
            {
                defLabel.GetComponent<Text>().text = dieTotal.ToString();
                defence = dieTotal;
            }
            if (typeCount == 2)
            {
                healLabel.GetComponent<Text>().text = dieTotal.ToString();
                healing = dieTotal;
            }
            if (typeCount == 3)
            {
                magicLabel.GetComponent<Text>().text = dieTotal.ToString();
                magic = dieTotal;
            }
        }

        /*
        player.GetComponent<PlayerScript>().RollAllDice();
        int[] playerResults = player.GetComponent<PlayerScript>().calcDieTotal();

        playerDamage = playerResults[0];
        playerDefense = playerResults[1];
        playerHealing = playerResults[2];
        playerMagic = playerResults[3];

        monster.GetComponent<MonsterScript>().RollAllDice();
        int[] monsterResults = monster.GetComponent<MonsterScript>().calcDieTotal();

        monsterDamage = monsterResults[0];
        monsterDefense = monsterResults[1];
        monsterHealing = monsterResults[2];
        monsterMagic = monsterResults[3];
        */

        //int[] totals = { atkTotal, defTotal, healTotal, magicTotal };
        //return totals;
    }

    public void resetRollFlags()
    {
        this.gameObject.GetComponent<Creature>().blankValue = 0;

        foreach(Transform die in DicePool.transform)
        {
            foreach (Transform face in die)
            {
                face.GetComponent<faceScript>().reset();
            }
        }
    }


    public void heal()
    {
        this.GetComponent<Creature>().hp += this.GetComponent<Creature>().healing;
        hpLabel.GetComponent<Text>().text = hp.ToString();
    }

    public void takeDamage(int incomingDamage)
    {
        int modifiedDamage = Math.Max(0, (incomingDamage - defence));
        hp -= modifiedDamage;

        if (hp <= 0)
        {
            die();
        }

        hpLabel.GetComponent<Text>().text = hp.ToString();
    }

    virtual public void die() { }

    public void addNewDie(string[] newSides, int[] newTypes, string state, string layer)
    {
        
        var newDie = Instantiate(DieTemplate, DicePool.transform);
        var dicesides = GameObject.Find("Dice Sides");

        for(int i = 0; i < 6; i++)
        {
            foreach(Transform side in dicesides.transform)
            {
                if (side.gameObject.name == newSides[i])
                {
                    var newFace = Instantiate(side.gameObject);
                    newFace.transform.parent = newDie.transform;
                    newFace.GetComponent<faceScript>().type = newTypes[i];
                    newDie.GetComponent<Dice>().setNewFace(newFace, i, state, layer);
                    
                    Destroy(newFace);
                    break;
                }
            }
        }
        newDie.GetComponent<Dice>().setDieFace(0);
    }
}

public class PlayerScript : Creature
{
    public int kills = 0;
    //public List<GameObject> DicePool = new List<GameObject>();


    //public List<string, int> diePool = new List<string, int>();

    //diePool.Add("blank", -1);

    // Start is called before the first frame update
    void Start()
    {
        //hp = 20;
        string[] faces = { "blank", "blank", "one", "one", "one", "two" };
        int[] types = { -1, -1, 0, 0, 0, 0 };

        addNewDie(faces, types, "inv", "Default");
        
        
        int[] types2 = { -1, -1, 1, 1, 1, 1 };
        addNewDie(faces, types2, "inv", "Default");

        repositionDice();
    }

    public void addScrap(int x = 0)
    {
        scrap += x;
        
        if (scrap >= SCRAP_LIMIT)
        {
            string[] blanks = { "blank", "blank", "blank", "blank", "blank", "blank" };
            int[] types = { -1, -1, -1, -1, -1, -1 };
            addNewDie(blanks, types, "loot", "Default");
            scrap -= SCRAP_LIMIT;
            repositionDice();
            addScrap();
        }
        
        scrapLabel.GetComponent<Text>().text = scrap.ToString();

        
    }

}
