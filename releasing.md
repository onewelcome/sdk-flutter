# Release steps for releasing the plugin to pub.dev

- Test develop
- Merge develop to release_x.x.x
- Test release_x.x.x
- Bump versions directly on release branch
- Make a PR from release to master branch and review
- Add tag on github on release branch
- Test the publish dry run (Make sure you update your local master branch)

  `dart pub publish --dry-run`
- Publish the release

  `dart pub publish`
- Merge release to master
- merge release to develop