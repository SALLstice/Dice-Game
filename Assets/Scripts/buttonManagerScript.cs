using System.Collections;
using System.Collections.Generic;
using UnityEngine.UI;
using UnityEngine;
using System;

public class buttonManagerScript : MonoBehaviour
{
    //public GameObject LootPanel;
    //public GameObject attackTotalLabel;
    //public GameObject defendTotalLabel;
    //public GameObject healTotalLabel;
    //public GameObject magicTotalLabel;
    //public GameObject monHealthLabel;
    //public GameObject monDamageLabel;
    public GameObject player;
    public GameObject gameManager;
    public GameObject monster;
    //private int dieTotal = 0;
    //public int playerHP;
    //public int monHP;
    
    //public int monsterDamage = 0;
    //public int monsterDefense;
    //public int monsterHealing;
    //public int monsterMagic;

    /* level -1: no roll effect
     * level 0: blank bonus
     * level 1: basic numbers
     * level 2: even/odd multiplier
     */



    public void ClickAttack()
    {
        //int kills = player.GetComponent<PlayerScript>().kills;
        //playerHP = player.GetComponent<PlayerScript>().hp;

        //int totalMonDamage = (Math.Max(0, monster.damage - player.defense) - player.healing) ;
        //int totalPlayerDamage = (Math.Max(0, playerDamage - monsterDefense) - monsterHealing);

        player.GetComponent<PlayerScript>().takeDamage(monster.GetComponent<Creature>().damage);
        monster.GetComponent<MonsterScript>().takeDamage(player.GetComponent<Creature>().damage);

        player.GetComponent<PlayerScript>().heal();
        monster.GetComponent<MonsterScript>().heal();

        player.GetComponent<PlayerScript>().resetRollFlags();
        monster.GetComponent<MonsterScript>().resetRollFlags();

        player.GetComponent<PlayerScript>().RollAllDice();
        monster.GetComponent<MonsterScript>().RollAllDice();

    }

    public void ClickStart()
    {
        /*
        player.GetComponent<PlayerScript>().takeDamage(-10);
        monster.GetComponent<MonsterScript>().takeDamage(15);

        player.GetComponent<PlayerScript>().RollAllDice();
        player.GetComponent<PlayerScript>().calcDieTotal();
        */

        //monster.GetComponent<MonsterScript>().setMonster("rat");
        var p = GameObject.Find("Player");
        var pdp = GameObject.Find("PlayerDicePool");
        var dh = GameObject.Find("DieHighlighter");
        var ip = GameObject.Find("InvPanel");

        

        Debug.Log(p);
        Debug.Log(ip);
        Debug.Log(pdp);
        Debug.Log(dh);
    }

    public void newMonsterButton()
    {
        var monsterlist = gameManager.GetComponent<GameManagerScript>().Monsters;

        var randmon = monsterlist[UnityEngine.Random.Range(0, monsterlist.Count)];

        gameManager.GetComponent<GameManagerScript>().setMonster(randmon);
    }
    
}
