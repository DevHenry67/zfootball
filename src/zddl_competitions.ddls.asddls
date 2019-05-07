@AbapCatalog.sqlViewName: 'ZVCOMPETITIONS'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Competitions'
@Search.searchable : true
@OData.publish: true
@UI.headerInfo:{ typeName: 'Competition', typeNamePlural: 'Competitions' }

define view zddl_competitions
  as select from zfb_competitions
{
  key id              as Id,
       
      @UI.lineItem: [{position: 10, importance: #HIGH }]     
      name            as Name,
      @UI.lineItem: [{position: 30, importance: #HIGH }]
      @Search: { defaultSearchElement: true, fuzzinessThreshold: 0.7 } 
      area_name       as Regio,
      code            as Code,
      emblemurl       as Url,
      plan_tier       as Tier,
      @UI.lineItem: [{position: 20, importance: #HIGH }]
      currentmatchday as CurrentMatchday,
      lastupdated     as LastUpdated
}
