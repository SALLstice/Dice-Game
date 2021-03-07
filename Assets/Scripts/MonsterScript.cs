using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class MonsterScript : Creature
{
    
    override public void die()
    {
        deleteAllDice();
        GetComponent<SpriteRenderer>().sprite = null;
        InvPanel.SetActive(true);
    }


}
public class Monster
{
    public int health;
    public int maxHealth;
    public string sprite;
    public List<DieConstruct> diePool;

    public Monster(int maxHealth, string sprite, List<DieConstruct> diePool)
    {
        this.health = maxHealth;
        this.maxHealth = maxHealth;
        this.sprite = sprite;
        this.diePool = diePool;
    }
}

public class DieConstruct
{
    public string[] faces;
    public int[] types;

    public DieConstruct(string[] faces, int[] types)
    {
        this.faces = faces;
        this.types = types;
    }
}