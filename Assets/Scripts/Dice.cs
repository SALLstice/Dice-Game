using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using System;
using Microsoft.CSharp;

/*give each die a collection of symbols: swords deal damage, shields block damage, potions heal
*any face can have any collections of symbols, but some also just have sword4 or whatever.
*also poison or burn symbols add status effects to the enemy. some faces affect those effects, like increasing duration or removing the effect for a larger single burst damage, etc
*clock face counts down each time its rolled and multiplies everything when it triggers
*there some effect where you can destory a die to gain some benefit. Or maybe a bomb face allows destorying other faces. maybe you cant replace other faces????
*bomb face lets you destory a face to do 5x its effect or something
*maybe you dont destory dice, they build up over time. would do a better job showing progression.
*each time a die is filled, the player gets a blank die.
*pear symbol: any face with a pair of symbols gets doubled
*spring symbol: adds 1 every time its rolled. can be used when rolled to add that much to any. comes in sword spring, shield spring and potion spring?
*something symbol: adds swords equal to half rolled shields, also exists vice versa
*scales: averages all base symbols to result
*something: reroll a die, but keep also the previous roll
*something face: reroll a die, keep new result
*mirror symbol: copies any other face
*something symbol: for every of these symbols rolled, they are each worth that much
* face which adds 1 or 2 or subtracts 1 or 2
* face whos value is the number of dice the opponent hasor your own die pool
* move reset die method into roll the die method
* face for cancel all 6s and have that script call player and monster to set the value of 6 at priority -1
* face for double all 6s
* negate any face, unlike bomb which destrys it would be more common
* face which adds scrap
*/

public class Dice : MonoBehaviour
{
    private SpriteRenderer[] diceSidesRend;
    private SpriteRenderer rend;
    public int showingIdx = 0;
    public GameObject showingFace;


    public GameObject monster;
    //private MonsterStats mon_stats;
    public GameObject player;
    private PlayerScript player_stats;
    public GameObject dieTotalLabel;
    public GameObject gameManager;
    List<GameObject> resultObjs = new List<GameObject>();
    List<Sprite> results = new List<Sprite>();

    //private int dieTotal = 0;
    
    private void Start()
    {
        //mon_stats = monster.GetComponent<MonsterStats>();
        //player_stats = player.GetComponent<PlayerScript>();

    }
    
    public void setDieFace(int idx)
    {
        //int value;
        GameObject face;
        rend = GetComponent<SpriteRenderer>();


        face = this.transform.GetChild(showingIdx).gameObject;
        showingFace = face;

        rend.sprite = face.GetComponent<SpriteRenderer>().sprite; //diceSidesRend[randomDiceSide].sprite;

        if (face.GetComponent<faceScript>().type == -1)
        {
            rend.color = Color.white;
        }
        if (face.GetComponent<faceScript>().type == 0)
        {
            rend.color = Color.red;
        }
        else if (face.GetComponent<faceScript>().type == 1)
        {
            rend.color = Color.grey;
        }
        else if (face.GetComponent<faceScript>().type == 2)
        {
            rend.color = Color.green;
        }
        else if (face.GetComponent<faceScript>().type == 3)
        {
            rend.color = Color.blue;
        }
    }

    public void RollTheDie()
    {

        showingIdx = UnityEngine.Random.Range(0, this.transform.childCount);

        setDieFace(showingIdx);
    }

    public void OnMouseUp()
    {
        int showidx = this.gameObject.GetComponent<Dice>().showingIdx;
        this.gameObject.transform.GetChild(showidx).GetComponent<faceScript>().OnMouseDown();
        
    }

    public void setNewFace(GameObject newFace, int index, string state, string sortLayer)
    {
        var testobj = Instantiate(newFace, this.gameObject.transform);

        testobj.transform.localPosition = new Vector3(0, 10, 0);
        testobj.transform.localScale = new Vector3(1, 1, 1);
        testobj.transform.SetSiblingIndex(index);
        testobj.gameObject.GetComponent<faceScript>().state = state;

        //testobj.GetComponent<SpriteRenderer>().sortingLayerName = sortLayer;
        testobj.GetComponent<SpriteRenderer>().sortingLayerName = "Hidden";
        testobj.name = testobj.GetComponent<SpriteRenderer>().sprite.name;
    }
}

 