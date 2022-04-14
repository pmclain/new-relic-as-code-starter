terraform {
  cloud {
    organization = "pmclain"

    workspaces {
      name = "pmclain"
    }
  }

  required_version = "~> 1.0"
  required_providers {
    newrelic = {
      source = "newrelic/newrelic"
    }
  }
}

provider "newrelic" {}

data "newrelic_entity" "meal_planner" {
  name   = "meal-planner"
  domain = "BROWSER"
}

resource "newrelic_one_dashboard" "meal_planner" {
  name = "Example"

  page {
    name = "Example"

    widget_billboard {
      column = 1
      row    = 1
      height = 2
      width  = 2
      title  = "Core web vitals - LCP"
      nrql_query {
        query = <<NRQL
          SELECT percentile(largestContentfulPaint, 75)
          FROM PageViewTiming
          WHERE appName = 'meal-planner'
        NRQL
      }
    }
  }
}
