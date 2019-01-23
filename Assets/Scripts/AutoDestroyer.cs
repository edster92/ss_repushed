using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AutoDestroyer : MonoBehaviour {
    [SerializeField]
    float timeToDestroy=5;
    void OnEnable()
    {
        Destroy(gameObject, timeToDestroy);
    }
}
