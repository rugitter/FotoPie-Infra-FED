output "repo_url" {
  description = "The URL of the repository - aka, aws_account_id.dkr.ecr.region.amazonaws.com/repositoryName"
  value = aws_ecr_repository.ecr_repo.repository_url
}