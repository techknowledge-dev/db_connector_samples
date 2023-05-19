package jp.co.techknowledge.execute;

import android.os.Bundle;

import com.google.android.material.floatingactionbutton.FloatingActionButton;
import com.google.android.material.snackbar.Snackbar;

import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;

import android.os.Handler;
import android.view.View;

import android.view.Menu;
import android.view.MenuItem;
import android.widget.Button;
import android.util.Log;

import jp.co.techknowledge.dbLib;
import jp.co.techknowledge.dblib.*;


public class MainActivity extends AppCompatActivity implements Runnable {
    enum fid {
        connect,
        beginTransaction,
        commitTransaction,
        rollbackTransaction,
        insert,
        disconnect
    }

    private fid _functionId;
    private dbLib _db = new dbLib();
    private Handler _handler = new Handler();


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        Toolbar toolbar = findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        Button connectButton = (Button)findViewById(R.id.connectButton);
        connectButton.setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View v) {
                _functionId = fid.connect;
                startThread();
            }
        });

        Button beginTransactionButton = (Button)findViewById(R.id.beginTransButton);
        beginTransactionButton.setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View v) {
                _functionId = fid.beginTransaction;
                startThread();
            }
        });

        Button commitTransactionButton = (Button)findViewById(R.id.commitTransButton);
        commitTransactionButton.setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View v) {
                _functionId = fid.commitTransaction;
                startThread();
            }
        });

        Button rollbackTransactionButton = (Button)findViewById(R.id.rollBackButton);
        rollbackTransactionButton.setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View v) {
                _functionId = fid.rollbackTransaction;
                startThread();
            }
        });

        Button insertButton = (Button)findViewById(R.id.insertButton);
        insertButton.setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View v) {
                _functionId = fid.insert;
                startThread();
            }
        });

        Button disconnectButton = (Button)findViewById(R.id.disconnectButton);
        disconnectButton.setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View v) {
                _functionId = fid.disconnect;
                startThread();
            }
        });
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    private void performExecute(){
        try {
            dbLib.status st = dbLib.status.Normal;

            switch(_functionId){
                case connect:
                    _db.setURL("http://192.168.0.18:8000/");		// <<==== ご利用環境に合わせて変更してください。
                    _db.setVerbose(true);
                    _db.setRawURL(false);
                    st = _db.connect();
                    break;

                case beginTransaction:
                    st = _db.beginTransaction();
                    break;
                case commitTransaction:
                    st = _db.commitTransaction();
                    break;
                case rollbackTransaction:
                    st = _db.rollbackTransaction();
                    break;
                case insert:
                    st = _db.execute("insert into emp (empno,ename,job) values (9999,'Jordan','MANAGER')");
                    break;

                case disconnect:
                    _db.disconnect();
                    break;
            }
            Log.v("test",st.toString());

            if(st != dbLib.status.Normal){
                String err = _db.getLastErrorText();
                if(err!=null){
                    Log.v("test", err);
                }
            }
            //

            _handler.post(new Runnable() {
                public void run() {
                    // set array adapter.
                    enableAll(true);
                }
            });

        }
        catch(Exception ex){
            Log.v("test",ex.getMessage());
            ex.printStackTrace();
        }
    }

    private void startThread(){
        enableAll(false);
        Thread thread = new Thread(this);
        thread.start();
    }

    @Override
    public void run() {
        performExecute();
    }

    private void enableAll(boolean b){
        Button button = (Button)findViewById(R.id.connectButton);
        button.setEnabled(b);
        button = (Button)findViewById(R.id.beginTransButton);
        button.setEnabled(b);
        button = (Button)findViewById(R.id.commitTransButton);
        button.setEnabled(b);
        button = (Button)findViewById(R.id.rollBackButton);
        button.setEnabled(b);
        button = (Button)findViewById(R.id.insertButton);
        button.setEnabled(b);
        button = (Button)findViewById(R.id.disconnectButton);
        button.setEnabled(b);
    }

}