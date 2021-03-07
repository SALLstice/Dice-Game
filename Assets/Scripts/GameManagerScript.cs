using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;


public class GameManagerScript : MonoBehaviour
{
    public GameObject monster;
    public GameObject player;
    public List<Monster> Monsters = new List<Monster>();

    void Start()
    {
        //List<string> diefaces1 = new List<string>;

        string[] diefaces1 = { "blank", "blank", "one", "one", "one", "one" };
        int[] dietypes1 = { -1, -1, 0, 0, 0, 0 };
        DieConstruct die1 = new DieConstruct(diefaces1, dietypes1);
        DieConstruct die2 = new DieConstruct(diefaces1, dietypes1);
        List<DieConstruct> ratDiePool = new List<DieConstruct>() { die1, die2 };
        Monster Rat = new Monster(3, "rat", ratDiePool);
        Monsters.Add(Rat);

        diefaces1 = new[] { "blank", "one", "one", "one", "two", "two" };
        dietypes1 = new[] { -1, 0, 0, 0, 0, 0 };
        die1 = new DieConstruct(diefaces1, dietypes1);
        die2 = new DieConstruct(diefaces1, dietypes1);
        List<DieConstruct> gobDiePool = new List<DieConstruct>() { die1, die2 };
        Monster Goblin = new Monster(6, "goblin", gobDiePool);
        Monsters.Add(Goblin);

        diefaces1 = new[] { "one", "two", "two", "two", "three", "four" };
        dietypes1 = new[] { 0, 0, 0, 0, 0, 0 };
        var diefaces2 = new[] { "one", "two", "two", "two", "three", "four" };
        var dietypes2 = new[] { 1, 1, 1, 1, 1, 1 };
        die1 = new DieConstruct(diefaces1, dietypes1);
        die2 = new DieConstruct(diefaces2, dietypes2);
        List<DieConstruct> treantDiePool = new List<DieConstruct>() { die1, die2 };
        Monster Treant = new Monster(30, "treant", treantDiePool);
        Monsters.Add(Treant);

        Application.targetFrameRate = 30;
    }

    public void setMonster(Monster mon)
    {
        //var mon = GameManager.GetComponent<GameManagerScript>().Monsters.Find(e => e.sprite == monstername);
        //var mon = GameManager.GetComponent<GameManagerScript>().Monsters[0];

        string monsterspritepath = "MonsterSprites/" + mon.sprite;
        monster.gameObject.GetComponent<SpriteRenderer>().sprite = Resources.Load<Sprite>(monsterspritepath);

        monster.gameObject.GetComponent<MonsterScript>().hp = mon.health;
        monster.gameObject.GetComponent<MonsterScript>().hpLabel.GetComponent<Text>().text = mon.health.ToString();

        monster.GetComponent<MonsterScript>().deleteAllDice();
        foreach (DieConstruct die in mon.diePool)
        {
            monster.GetComponent<MonsterScript>().addNewDie(die.faces, die.types, "inv", "Default");
        }
        //string[] faces = { "blank", "blank", "one", "one", "one", "two" };
        //int[] types = { -1, -1, 0, 0, 0, 0 };

        //addNewDie(faces, types, "inv", "Default");
        //addNewDie(faces, types, "inv", "Default");

        monster.GetComponent<MonsterScript>().repositionDice();

        player.GetComponent<PlayerScript>().RollAllDice();
        monster.GetComponent<MonsterScript>().RollAllDice();


    }

}

