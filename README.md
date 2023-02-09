# NoodoeInterview

## Diagram
![image](https://github.com/jack45j/NoodoeInterview/blob/main/Noodoe.png)

### Known issues
  - There are some memory leaks in Adapter and Presenter caused by strong reference of controllers and retain cycle of adapter.

### Could be better
  - Integrate DataStore into HttpClientModule.
  - HttpClientModule with generic decoddable response.
  - Clearer i/o of module's outputs.

### TODO
  - Tests of adapters (stub the URLRequest and spy the func called.)
  - Error Handlings
