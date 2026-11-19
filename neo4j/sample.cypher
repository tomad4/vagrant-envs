// Example graph for a software delivery team.
// Idempotent: MERGE lets you run this file repeatedly without duplicates.

// 10 nodes
MERGE (ada:Person {id: 'person-ada'})
  ON CREATE SET ada.name = 'Ada Lovelace', ada.role = 'Product manager'
MERGE (grace:Person {id: 'person-grace'})
  ON CREATE SET grace.name = 'Grace Hopper', grace.role = 'Platform engineer'
MERGE (alan:Person {id: 'person-alan'})
  ON CREATE SET alan.name = 'Alan Turing', alan.role = 'Backend engineer'
MERGE (margaret:Person {id: 'person-margaret'})
  ON CREATE SET margaret.name = 'Margaret Hamilton', margaret.role = 'Engineering lead'
MERGE (linus:Person {id: 'person-linus'})
  ON CREATE SET linus.name = 'Linus Torvalds', linus.role = 'Database engineer'
MERGE (orion:Team {id: 'team-orion'})
  ON CREATE SET orion.name = 'Orion Platform'
MERGE (atlas:Team {id: 'team-atlas'})
  ON CREATE SET atlas.name = 'Atlas Data'
MERGE (graphHub:Project {id: 'project-graph-hub'})
  ON CREATE SET graphHub.name = 'Graph Hub', graphHub.status = 'active'
MERGE (neo4j:Technology {id: 'technology-neo4j'})
  ON CREATE SET neo4j.name = 'Neo4j', neo4j.category = 'Graph database'
MERGE (kubernetes:Technology {id: 'technology-kubernetes'})
  ON CREATE SET kubernetes.name = 'Kubernetes', kubernetes.category = 'Platform'

// 20 relationships
MERGE (ada)-[:MEMBER_OF]->(orion)
MERGE (grace)-[:MEMBER_OF]->(orion)
MERGE (alan)-[:MEMBER_OF]->(orion)
MERGE (margaret)-[:MEMBER_OF]->(orion)
MERGE (linus)-[:MEMBER_OF]->(atlas)
MERGE (orion)-[:COLLABORATES_WITH]->(atlas)
MERGE (ada)-[:OWNS]->(graphHub)
MERGE (margaret)-[:LEADS]->(graphHub)
MERGE (grace)-[:CONTRIBUTES_TO]->(graphHub)
MERGE (alan)-[:CONTRIBUTES_TO]->(graphHub)
MERGE (linus)-[:CONTRIBUTES_TO]->(graphHub)
MERGE (graphHub)-[:USES]->(neo4j)
MERGE (graphHub)-[:DEPLOYED_ON]->(kubernetes)
MERGE (grace)-[:OPERATES]->(kubernetes)
MERGE (linus)-[:MAINTAINS]->(neo4j)
MERGE (ada)-[:COLLABORATES_WITH]->(grace)
MERGE (grace)-[:COLLABORATES_WITH]->(alan)
MERGE (alan)-[:COLLABORATES_WITH]->(linus)
MERGE (margaret)-[:COLLABORATES_WITH]->(ada)
MERGE (neo4j)-[:RUNS_ON]->(kubernetes);
