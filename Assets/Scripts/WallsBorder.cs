using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WallsBorder : BasedGameObjects {

    public override void Initialized()
    {
        Type = Types.wall;
        CollusionMassive = new Types[] { Types.bulet, Types.hazard, Types.bonys };
    }
    public override void Impact(BasedGameObjects objectImpact)
    {
        objectImpact.OutOfGameField();

    }

}
