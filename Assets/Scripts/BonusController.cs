using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BonusController : BasedGameObjects {

    public GameObject BonusExploisionPartickle;
    public BonusContainer [] Bonuses;

    public override void Initialized()
    {
        Type = Types.bonys;
        CollusionMassive = new Types[] { Types.player };
    }
    public override void Death()
    {
        GameObject explousion = (GameObject) Instantiate(BonusExploisionPartickle, transform.position, Quaternion.identity, transform.parent);
        Destroy(gameObject);
    }

    public override void Impact(BasedGameObjects objectImpact)
    {
        foreach (BonusContainer Bonus in Bonuses)
        {
            Done_GameController.Instance.AddBonus(Bonus);
        }
        Death();
    }

}
