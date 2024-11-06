// location
param location string = resourceGroup().location

// Application Insights name
param applicationInsightsName string = 'app-${uniqueString(resourceGroup().id)}'

// Log Application for Application Insights name
param logAnalyticsWorkspaceName string = 'log-${uniqueString(resourceGroup().id)}'

// Service Principal ID
param principalId string

// Log Analytics Workspace
resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: logAnalyticsWorkspaceName
  location: location
  tags: {
    environment: 'dev'
  }
}

// Application Insights
resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: applicationInsightsName
  location: location
  kind: 'web'
  tags: {
    environment: 'dev'
  }
  properties: {
    WorkspaceResourceId: logAnalyticsWorkspace.id
    Application_Type: 'web'
    DisableIpMasking: true
  }
}

// "Monitoring Metrics Publisher" Role
resource roleDef 'Microsoft.Authorization/roleDefinitions@2022-05-01-preview' existing = {
  scope: resourceGroup()
  name: '3913510d-42f4-4e42-8a64-420c390055eb' // Monitoring Metrics Publisher
}

// Attach role to Service Principal
resource spRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: applicationInsights
  name: guid(applicationInsights.id, principalId, roleDef.name)
  properties: {
    roleDefinitionId: roleDef.id
    principalId: principalId
    principalType: 'ServicePrincipal'
  }
}

// Display application insights connection string
output connectionString string = applicationInsights.properties.ConnectionString
