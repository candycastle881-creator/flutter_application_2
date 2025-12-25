Publishing `app-ads.txt` via GitHub Pages

This repository includes `docs/app-ads.txt` which can be served via GitHub Pages.

Steps to publish using the `docs/` folder (GitHub Pages):

1. Commit the `docs/app-ads.txt` file and push to your GitHub repo (example commands):

   ```bash
   git add docs/app-ads.txt scripts/verify_app_ads.sh
   git commit -m "Add app-ads.txt and verification script for GitHub Pages"
   git push origin main
   ```

2. Enable GitHub Pages for the repository using the `docs` folder as the source:
   - Go to your repository Settings → Pages.
   - Under "Build and deployment", choose "Deploy from a branch".
   - Select branch `main` and folder `/docs`.
   - Save. GitHub will publish the site shortly.

3. After publishing, your file will be available at:

   `https://<username>.github.io/<repo>/app-ads.txt`

   Replace `<username>` and `<repo>` with your GitHub username and repository name.

4. Verify the hosted file is reachable using the included verification script:

   ```bash
   chmod +x scripts/verify_app_ads.sh
   ./scripts/verify_app_ads.sh "https://<username>.github.io/<repo>/app-ads.txt"
   ```

5. Update your Play Store developer website URL:
   - Log into Google Play Console → Select your app → Store presence → Store listing → Developer website.
   - Enter the GitHub Pages URL root (e.g., `https://<username>.github.io`) or your own website where the `app-ads.txt` file is hosted.
   - Save and publish the store listing update.

Notes about App Store / Ad networks:
- For Google AdMob/Ad Manager, make sure the Play Store listing points to a developer website that hosts `app-ads.txt` at the root.
- For Apple's App Store, the developer website listed in App Store Connect should similarly host the file if required by the ad network.

If you don't want to use GitHub Pages, you can upload `app-ads.txt` to any website you control and use the same verification script against that URL.

If you want, I can:
- Create a local `gh-pages` branch and commit these files for you (you still must `git push`), or
- Attempt to push to the remote if you give push access/credentials (I can't do this autonomously).