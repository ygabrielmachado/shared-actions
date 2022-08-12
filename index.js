const core = require('@actions/core');
const exec = require('@actions/exec');

async function run() {

    try {
        const envType = core.getInput('env');
        const regionType = core.getInput('region');
        const applicationName = core.getInput('application-name');
        const src = __dirname;

        const expr = core.getInput('sharedScript');
        switch (expr) {
            case 'healthcheck':
                await exec.exec(`${src}/healthcheck.sh ${envType} `);
                break;
            case 'deploy-beanstalk':
                await exec.exec(`${src}/deploy-app-beanstalk.sh ${envType} ${regionType} ${applicationName}`);
                break;
            case 'deploy-cloudfront':
                await exec.exec(`${src}/deploy-app-cloudfront.sh ${applicationName} ${envType}`);
                break;
            case 'empty-bucket':
                await exec.exec(`${src}/empty-bucket.sh ${applicationName} ${envType}`);
                break;
            default:
                console.log(`Sorry, we are out of ${expr}.`);
        }

    } catch (error) {
        core.setFailed(error.message);
    }
}

run();
