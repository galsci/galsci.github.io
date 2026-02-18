require 'httparty'
require 'jekyll'

module GithubRepos
  class GithubReposGenerator < Jekyll::Generator
    safe true
    priority :high

    def generate(site)
      if site.data['repositories'] && site.data['repositories']['github_repos']
        site.data['repositories']['github_repos_data'] = []
        
        site.data['repositories']['github_repos'].each do |repo|
          owner, name = repo.split('/')
          
          begin
            # Fetch repository data from GitHub API
            url = "https://api.github.com/repos/#{owner}/#{name}"
            response = HTTParty.get(url, headers: {
              'User-Agent' => 'Jekyll-Site'
            })
            
            if response.code == 200
              repo_data = response.parsed_response
              site.data['repositories']['github_repos_data'] << {
                'name' => repo_data['name'],
                'full_name' => repo_data['full_name'],
                'description' => repo_data['description'],
                'html_url' => repo_data['html_url'],
                'stars' => repo_data['stargazers_count'],
                'forks' => repo_data['forks_count'],
                'language' => repo_data['language'],
                'owner' => repo_data['owner']['login']
              }
              puts "✓ Fetched data for #{repo}"
            else
              puts "✗ Failed to fetch #{repo}: HTTP #{response.code}"
              # Add placeholder data if API fails
              site.data['repositories']['github_repos_data'] << {
                'name' => name,
                'full_name' => repo,
                'description' => '',
                'html_url' => "https://github.com/#{repo}",
                'stars' => 0,
                'forks' => 0,
                'language' => '',
                'owner' => owner
              }
            end
          rescue => e
            puts "✗ Error fetching #{repo}: #{e.message}"
            # Add placeholder data if fetch fails
            site.data['repositories']['github_repos_data'] << {
              'name' => name,
              'full_name' => repo,
              'description' => '',
              'html_url' => "https://github.com/#{repo}",
              'stars' => 0,
              'forks' => 0,
              'language' => '',
              'owner' => owner
            }
          end
        end
      end
    end
  end
end
