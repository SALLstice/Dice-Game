using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class skipLootButtonScript : MonoBehaviour
{
    public GameObject dieHighlighter;
    public GameObject invPanel;
    public GameObject gamePanel;
    public GameObject player;

    void OnMouseUp()
    {
        dieHighlighter.transform.parent = invPanel.transform;
        dieHighlighter.GetComponent<SpriteRenderer>().sortingLayerName = "Hidden";
        this.transform.parent.gameObject.SetActive(false);
        gamePanel.SetActive(true);

        player.GetComponent<PlayerScript>().addScrap(invPanel.GetComponent<invPanelScript>().scrapLoot);
        
    }
}
