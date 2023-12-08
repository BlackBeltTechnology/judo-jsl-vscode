'use strict';

import * as path from 'path';
import * as os from 'os';
import * as net from 'net';

import {Trace} from 'vscode-jsonrpc';
import { commands, window, workspace, ExtensionContext, Uri } from 'vscode';
import { LanguageClient, LanguageClientOptions, ServerOptions, StreamInfo } from 'vscode-languageclient/node';

let lc: LanguageClient;

export function activate(context: ExtensionContext) {
    // The server is a locally installed in src/jsl
    let launcher = os.platform() === 'win32' ? 'jsl-standalone.bat' : 'jsl-standalone';
    let script = context.asAbsolutePath(path.join('src', 'jsl', 'bin', launcher));

    let serverOptions: ServerOptions = {
        run : { command: script },
        debug: { command: script, args: [], options: { env: createDebugEnv() } },
    };

    /* TODO: Make local server run configurable
    let connectionInfo = {
        port: 5007
    };

    let serverOptions = () => {
        // Connect to language server via socket
        let socket = net.connect(connectionInfo);
        let result: StreamInfo = {
            writer: socket,
            reader: socket
        };
        return Promise.resolve(result);
    };
    */

    let clientOptions: LanguageClientOptions = {
        documentSelector: ['jsl'],
        synchronize: {
            fileEvents: workspace.createFileSystemWatcher('**/*.jsl')
        }
    };
    
    // Create the language client and start the client.
    lc = new LanguageClient('Xtext Server', serverOptions, clientOptions);
        
    // enable tracing (.Off, .Messages, Verbose)
    lc.setTrace(Trace.Verbose);
    lc.start();

    // Push the disposable to the context's subscriptions so that the
    // client can be deactivated on extension deactivation
    //context.subscriptions.push(disposable);
}

export function deactivate() {
    return lc.stop();
}

function createDebugEnv() {
    return Object.assign({
        JAVA_OPTS:"-Xdebug -Xrunjdwp:server=y,transport=dt_socket,address=8000,suspend=n,quiet=y"
    }, process.env)
}
